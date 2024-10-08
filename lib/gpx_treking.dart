import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:gpx/gpx.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_animated_marker/flutter_map_animated_marker.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:my_app/loading.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math'; // 삼각함수 계산을 위해 필요
import 'done.dart';
import 'package:flutter_background/flutter_background.dart'; // 백그라운드 패키지 추가
import 'package:workmanager/workmanager.dart'; // 백그라운드 작업을 위한 패키지
import 'done.dart';

class TrackingPage extends StatefulWidget {
  final String courseName;
  final int userCourseId;
  TrackingPage({required this.courseName, required this.userCourseId});
  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class AppConstants {
  static final NLatLng kangwondoCenter = NLatLng(37.5550, 128.2098);
}

class _TrackingPageState extends State<TrackingPage>
    with TickerProviderStateMixin {
  late final AnimatedMapController _animatedMapController;
  StreamSubscription<Position>? _positionStream;
  StreamSubscription? _compassStream;
  StreamSubscription? _accelerometerStreamSubscription;
  StreamSubscription? _magnetometerStreamSubscription;
  final List<NLatLng> _routePoints = []; // 기존 경로 포인트
  final List<NMarker> _markers = [];
  NLatLng? _currentLocation;
  NLatLng? _previousLocation; // 이전 위치 저장
  double _currentHeading = 0.0; // 바라보는 방향
  final String _url = 'http://43.203.197.86:8080';
  double _totalDistance = 0.0;

  double _totalCalories = 0.0;
  double _currentAltitude = 0.0; // 고도값
  Duration _totalTime = Duration.zero;
  Timer? _timer;
  bool _isTracking = false;
  bool _isPaused = false; // pause 상태를 추가
  bool _isLoading = false;
  NaverMapController? _naverMapController;

  @override
  void initState() {
    super.initState();

    _initializeBackgroundTracking(); // 백그라운드 트래킹 초기화
  }

  @override
  void dispose() async {
    _disposeResources(); // 모든 비동기 취소 작업을 안전하게 처리
    super.dispose();
  }

  Future<void> _disposeResources() async {
    try {
      // 지도 컨트롤러가 null이 아닌 경우 오버레이 삭제
      if (_naverMapController != null) {
        await _naverMapController!.clearOverlays();
      }

      // 위치 추적 스트림이 존재하면 취소
      if (_positionStream != null) {
        await _positionStream!.cancel();
        _positionStream = null;
      }

      // 타이머가 존재하면 취소
      if (_timer != null) {
        _timer!.cancel();
        _timer = null;
      }

      // 가속도계와 자기장 스트림 취소
      if (_accelerometerStreamSubscription != null) {
        await _accelerometerStreamSubscription!.cancel();
        _accelerometerStreamSubscription = null;
      }

      if (_magnetometerStreamSubscription != null) {
        await _magnetometerStreamSubscription!.cancel();
        _magnetometerStreamSubscription = null;
      }
    } catch (e) {
      // 예외 발생 시 로그 출력 (디버깅용)
      print("Error while disposing resources: $e");
    }
  }

  /// 백그라운드 서비스 초기화
  Future<void> _initializeBackgroundTracking() async {
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: 'Tracking in progress',
      notificationText: 'Tracking your movement.',
      enableWifiLock: true,
    );

    bool hasPermissions = await FlutterBackground.hasPermissions;
    if (!hasPermissions) {
      await FlutterBackground.initialize(androidConfig: androidConfig);
    }

    Workmanager().initialize(_callbackDispatcher, isInDebugMode: true);
  }

  /// 백그라운드 작업 설정
  void _registerBackgroundTask() {
    Workmanager().registerPeriodicTask(
      'trackLocation',
      'trackLocationTask',
      frequency: Duration(minutes: 15),
    );
  }

  /// WorkManager 백그라운드 작업 콜백
  static void _callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      // 백그라운드에서 수행할 위치 추적 작업
      print('Background task running');
      // 위치 추적 관련 로직 추가
      return Future.value(true);
    });
  }

  void _startCompass() {
    List<double>? accelerometerValues;
    List<double>? magnetometerValues;

    _accelerometerStreamSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      accelerometerValues = [event.x, event.y, event.z];
      _calculateHeading(accelerometerValues, magnetometerValues);
    });

    _magnetometerStreamSubscription =
        magnetometerEvents.listen((MagnetometerEvent event) {
      magnetometerValues = [event.x, event.y, event.z];
      _calculateHeading(accelerometerValues, magnetometerValues);
    });
  }

  void _calculateHeading(List<double>? accelerometerValues,
      List<double>? magnetometerValues) async {
    if (accelerometerValues != null && magnetometerValues != null) {
      List<double> R = List.filled(9, 0.0);
      List<double> I = List.filled(9, 0.0);
      List<double> orientation = List.filled(3, 0.0);

      if (_getRotationMatrix(R, I, accelerometerValues, magnetometerValues)) {
        _getOrientation(R, orientation);

        // Azimuth 값에 필터 적용
        double azimuth = (orientation[0] * (180 / pi) + 360) % 360;
        // 시계방향으로 5도 보정
        azimuth = (azimuth + 30) % 360;
        // 간단한 필터링 적용 (이전 값들과 평균)
        double filteredAzimuth = (_currentHeading + azimuth) / 2;

        setState(() {
          _currentHeading = filteredAzimuth;
        });

        // 지도 오버레이 방향 업데이트
        if (_naverMapController != null) {
          _updateLocationOverlayBearing();
        }
      }
    }
  }

  /// 회전 행렬을 계산하는 함수
  bool _getRotationMatrix(List<double> R, List<double> I, List<double> gravity,
      List<double> geomagnetic) {
    double Ax = gravity[0];
    double Ay = gravity[1];
    double Az = gravity[2];

    double Ex = geomagnetic[0];
    double Ey = geomagnetic[1];
    double Ez = geomagnetic[2];

    double Hx = Ey * Az - Ez * Ay;
    double Hy = Ez * Ax - Ex * Az;
    double Hz = Ex * Ay - Ey * Ax;

    double normH = sqrt(Hx * Hx + Hy * Hy + Hz * Hz);
    if (normH < 0.1) {
      // 장치가 거의 평행일 때
      return false;
    }

    double invH = 1.0 / normH;
    Hx *= invH;
    Hy *= invH;
    Hz *= invH;

    double invA = 1.0 / sqrt(Ax * Ax + Ay * Ay + Az * Az);
    Ax *= invA;
    Ay *= invA;
    Az *= invA;

    double Mx = Ay * Hz - Az * Hy;
    double My = Az * Hx - Ax * Hz;
    double Mz = Ax * Hy - Ay * Hx;

    R[0] = Hx;
    R[1] = Hy;
    R[2] = Hz;
    R[3] = Mx;
    R[4] = My;
    R[5] = Mz;
    R[6] = Ax;
    R[7] = Ay;
    R[8] = Az;

    return true;
  }

  /// 방향을 계산하는 함수
  void _getOrientation(List<double> R, List<double> orientation) {
    orientation[0] = atan2(R[1], R[4]); // Azimuth
    orientation[1] = asin(-R[7]); // Pitch
    orientation[2] = atan2(-R[6], R[8]); // Roll
  }

  void _updateLocationOverlayBearing() async {
    if (_naverMapController != null && _currentLocation != null) {
      final locationOverlay = await _naverMapController!.getLocationOverlay();

      // 현재 위치 오버레이가 있는지 확인하고 아이콘 회전
      if (locationOverlay != null) {
        locationOverlay.setBearing(_currentHeading); // 휴대폰 방향으로 회전
      }
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 100,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () async {
                  // API 호출
                  Navigator.pop(context); // Done 누르면 bottom sheet 닫기
                  _onDoneButtonPressed();
                },
                child: Text('Done', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 45),
                  backgroundColor: Color(0xff1dbe92),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// 기존 코드 중 Done 버튼 클릭 시 페이지 전환 부분 수정
  void _onDoneButtonPressed() async {
    // 모든 위치 추적과 센서 스트림 종료

    await _accelerometerStreamSubscription?.cancel(); // 가속도계 스트림을 await
    await _magnetometerStreamSubscription?.cancel(); // 자기장 스트림을 await
    // Done 버튼 눌렀을 때 데이터를 받아서 SummaryPage로 전송
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            TrackingSummaryPage(
          totalDistance: _totalDistance,
          totalCalories: _totalCalories,
          maxAltitude: _currentAltitude,
          totalTime: _totalTime,
          userCourseId: widget.userCourseId,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // 오른쪽에서 왼쪽으로 애니메이션 시작 위치
          const end = Offset.zero; // 종료 위치
          const curve = Curves.fastLinearToSlowEaseIn;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')),
      );
      return;
    }
    _customizeLocationOverlay(); // 위치 오버레이 커스텀
    _startTracking(); // 위치 권한이 허용되었을 때만 추적 시작
  }

  Future<void> _customizeLocationOverlay() async {
    _naverMapController?.setLocationTrackingMode(NLocationTrackingMode.face);
    MyLocationTrackingMode;
    // 현재 위치 오버레이 가져오기
    final locationOverlay = await _naverMapController!.getLocationOverlay();

    locationOverlay.setIsVisible(true);
    locationOverlay.setBearing(0);
    locationOverlay.setIcon(
      // 아이콘 설정

      NOverlayImage.fromAssetImage('assets/mygps.png'),
    );
    locationOverlay.setIconSize(Size(40, 40));
    locationOverlay
        .setSubIcon(NOverlayImage.fromAssetImage('assets/mark_sub.png'));
    locationOverlay.setSubIconSize(Size(20, 20));

    locationOverlay.setCircleRadius(15);
    locationOverlay.setCircleOutlineWidth(0);
    locationOverlay.setCircleOutlineColor(Colors.transparent);
  }

  Future<double> getCurrentAltitude() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best, // Best accuracy for altitude
      );
      return position.altitude; // 고도 값을 반환
    } catch (e) {
      print("Error getting altitude: $e");
      return 0;
    }
  }

  Future<void> _loadGpxFile() async {
    String courseName = widget.courseName.replaceAll(' ', '_');
    String apiUrl = _url + '/api/gpx/$courseName';

    // Make API request to fetch GPX data
    http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      String gpxData = response.body;
      final gpx = GpxReader().fromString(gpxData);

      setState(() {
        _routePoints.addAll(gpx.trks[0].trksegs[0].trkpts.map((pt) {
          return NLatLng(pt.lat!, pt.lon!);
        }));

        if (_routePoints.isNotEmpty) {
          final marker_start = NMarker(
            id: 'start',
            position: _routePoints.first,
            icon: NOverlayImage.fromAssetImage('assets/Go.png'),
          );
          _naverMapController?.addOverlay(marker_start);
          final marker_end = NMarker(
            id: 'end',
            position: _routePoints.last,
            icon: NOverlayImage.fromAssetImage('assets/End.png'),
          );
          _naverMapController?.addOverlay(marker_end);
          // 폴리라인 생성
          final polyline = NPolylineOverlay(
            id: 'route',
            coords: _routePoints,
            color: Color(0xff0d615c),
            width: 5,
          );
          _naverMapController?.addOverlay(polyline);

          // 페이지 로드 시 초기 줌 레벨을 12.5로 설정
          final middlePoint = NLatLng(
            (_routePoints.first.latitude + _routePoints.last.latitude) / 2,
            (_routePoints.first.longitude + _routePoints.last.longitude) / 2,
          );

          final cameraUpdate = NCameraUpdate.withParams(
              target: middlePoint, zoom: 11.5, bearing: 0);

          cameraUpdate.setAnimation(
              animation: NCameraAnimation.fly, duration: Duration(seconds: 2));
          _naverMapController?.updateCamera(cameraUpdate);
        }
      });
    } else {
      // Handle API error
      print('Failed to load GPX data. Error: ${response.statusCode}');
    }
  }

  void _startTracking() async {
    _startCompass();
    setState(() {
      _isTracking = true;
      if (!_isPaused) {
        _totalTime = Duration.zero;
        _totalDistance = 0.0; // 거리 초기화
        _totalCalories = 0.0; // 칼로리 초기화
      }
      _isPaused = false; // paused 상태 초기화
    });

    // 고도값 가져오기
    _currentAltitude = await getCurrentAltitude();

    // 현 위치 추적 스트림 시작
    _positionStream =
        Geolocator.getPositionStream().listen((Position position) {
      final currentPoint = NLatLng(position.latitude, position.longitude);

      setState(() {
        _currentLocation = currentPoint;

        // 거리 계산
        if (_previousLocation != null) {
          final distance = Geolocator.distanceBetween(
            _previousLocation!.latitude,
            _previousLocation!.longitude,
            _currentLocation!.latitude,
            _currentLocation!.longitude,
          );
          _totalDistance += distance / 1000; // 미터를 km로 변환
        }

        // 칼로리 계산 (간단히 1km당 50칼로리 소모로 가정)
        _totalCalories = _totalDistance * 50;

        // 이전 위치 업데이트
        _previousLocation = _currentLocation;

        final cameraUpdate = NCameraUpdate.withParams(
            target: currentPoint, zoom: 15.0, bearing: 0);

        cameraUpdate.setAnimation(
            animation: NCameraAnimation.fly, duration: Duration(seconds: 2));
        _naverMapController?.updateCamera(cameraUpdate);
      });
    });

    // 타이머 시작
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _totalTime += Duration(seconds: 1);
      });
    });
  }

  void _stopTracking() async {
    setState(() {
      _isTracking = false;
      _isPaused = true; // 일시정지 상태 유지
    });
    // 위치 추적 스트림과 타이머를 확실히 취소하기 위해 await 사용
    if (_positionStream != null) {
      await _positionStream!.cancel();
      _positionStream = null;
    }

    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadingScreen();
    } else {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor:
              Colors.transparent, // Set the background color to transparent
          elevation: 0, // Remove the shadow
        ),
        body: Stack(
          children: [
            Positioned.fill(
              bottom: 200,
              child: NaverMap(
                forceGesture: true,

                options: const NaverMapViewOptions(
                    rotationGesturesEnable: false,
                    initialCameraPosition: NCameraPosition(
                        target: NLatLng(37.5558, 128.2092), // 강원도 맵 위치
                        zoom: 15,
                        bearing: 0,
                        tilt: 0),
                    mapType: NMapType.terrain,
                    activeLayerGroups: [NLayerGroup.mountain],
                    scrollGesturesFriction: 0.0,
                    zoomGesturesFriction: 0.0,
                    rotationGesturesFriction: 0.0,
                    minZoom: 8, // default is 0

                    extent: NLatLngBounds(
                      southWest: NLatLng(34.0, 124.0),
                      northEast: NLatLng(43.0, 132.0),
                    ),
                    locale: Locale('en', 'US')), // 지도 옵션을 설정할 수 있습니다.

                onMapReady: (controller) {
                  _naverMapController = controller;

                  _loadGpxFile();
                },
              ),
            ),
            // 정보 표시할 Container
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, -2),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoCard('Distance',
                            '${_totalDistance.toStringAsFixed(2)} km'),
                        _buildInfoCard('Altitude',
                            '${_currentAltitude.toStringAsFixed(1)} m'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoCard('Calories',
                            '${_totalCalories.toStringAsFixed(0)} kcal'),
                        _buildInfoCard('Time', _formatDuration(_totalTime)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed:
                    _isTracking ? _stopTracking : _checkLocationPermission,
                child: Text(_isTracking ? 'Pause' : 'Start',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff1dbe92),
                  minimumSize: Size(300, 45),
                ),
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  _showBottomSheet(context); // 점 세 개 버튼을 눌렀을 때 bottom sheet 열기
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      width: 148,
      height: 100,
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12, color: Colors.grey, fontFamily: 'Pretendard')),
          SizedBox(height: 16.0),
          Text(value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
