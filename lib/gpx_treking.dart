import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:gpx/gpx.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_animated_marker/flutter_map_animated_marker.dart';
import 'package:my_app/loading.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class TrackingPage extends StatefulWidget {
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
  final List<NLatLng> _routePoints = []; // 기존 경로 포인트
  final List<NMarker> _markers = [];
  NLatLng? _currentLocation;
  NLatLng? _previousLocation; // 이전 위치 저장
  double _currentHeading = 0.0; // 바라보는 방향
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
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _timer?.cancel();

    super.dispose();
  }

  void _showBottomSheet(BuildContext context) {
    double _currentVolume = 0.5; // 초기 볼륨 값
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 200,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Volumn',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              Row(
                children: [
                  Icon(Icons.volume_mute, size: 30, color: Colors.black),
                  Expanded(
                    child: Slider(
                      value: _currentVolume,
                      onChanged: (newValue) {
                        setState(() {
                          _currentVolume = newValue;
                        });
                      },
                      min: 0.0,
                      max: 1.0,
                      activeColor: Color(0xFF1DBE92),
                      inactiveColor: Colors.grey[300],
                    ),
                  ),
                  Icon(Icons.volume_up, size: 30, color: Colors.black),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  // API 호출
                  await _sendDoneAPI();
                  Navigator.pop(context); // Done 누르면 bottom sheet 닫기
                },
                child: Text('Done', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff1dbe92),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _sendDoneAPI() async {
    // 서버로 Done API 요청
    try {
      final response = await http.post(
        Uri.parse('https://your-server-endpoint.com/api/done'), // 여기에 서버 주소 입력
        headers: {'Content-Type': 'application/json'},
        body: '{"totalDistance": $_totalDistance, "calories": $_totalCalories}',
      );

      if (response.statusCode == 200) {
        print('API 호출 성공!');
      } else {
        print('API 호출 실패!');
      }
    } catch (e) {
      print('API 호출 중 오류 발생: $e');
    }
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
    _naverMapController?.setLocationTrackingMode(NLocationTrackingMode.follow);
    // 현재 위치 오버레이 가져오기
    final locationOverlay = await _naverMapController!.getLocationOverlay();
    locationOverlay.setIsVisible(true);

    locationOverlay.setIcon(
      // 아이콘 설정
      NOverlayImage.fromAssetImage('assets/mygps.png'),
    );
    locationOverlay.setIconSize(Size(40, 40));
    locationOverlay
        .setSubIcon(NOverlayImage.fromAssetImage('assets/mark_sub.png'));
    locationOverlay.setSubIconSize(Size(20, 20));
    locationOverlay.setSubAnchor(NPoint(0.5, 1.0));
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
    String gpxData = await DefaultAssetBundle.of(context)
        .loadString('assets/chiaksan_0000000001.gpx');
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

        final cameraUpdate =
            NCameraUpdate.scrollAndZoomTo(target: middlePoint, zoom: 11.5);

        cameraUpdate.setAnimation(
            animation: NCameraAnimation.fly, duration: Duration(seconds: 2));
        _naverMapController?.updateCamera(cameraUpdate);
      }
    });
  }

  void _startTracking() async {
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
        _currentHeading = position.heading; // 바라보는 방향

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

        final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
          target: currentPoint,
          zoom: 15.0,
        );

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

  void _stopTracking() {
    setState(() {
      _isTracking = false;
      _isPaused = true; // 일시정지 상태 유지
    });
    _positionStream?.cancel();
    _timer?.cancel();
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
              bottom: 250,
              child: NaverMap(
                forceGesture: true,

                options: const NaverMapViewOptions(
                    rotationGesturesEnable: false,
                    initialCameraPosition: NCameraPosition(
                        target: NLatLng(37.5558, 128.2092), // 강원도 맵 위치
                        zoom: 15,
                        bearing: 0,
                        tilt: 0),
                    mapType: NMapType.basic,
                    activeLayerGroups: [
                      NLayerGroup.building,
                      NLayerGroup.transit,
                      NLayerGroup.mountain
                    ],
                    scrollGesturesFriction: 0.0,
                    zoomGesturesFriction: 0.0,
                    rotationGesturesFriction: 0.0,
                    minZoom: 8, // default is 0

                    extent: NLatLngBounds(
                      southWest: NLatLng(33.0, 124.0),
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
                height: MediaQuery.of(context).size.height * 0.4,
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
                      children: [
                        SizedBox(width: 25.0),
                        ElevatedButton(
                          onPressed: () => {},
                          child: Text('Course Name >',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff1dbe92),
                            minimumSize: Size(100, 44),
                          ),
                        ),
                        SizedBox(width: 100.0),
                        SvgPicture.asset('assets/sos.svg'),
                      ],
                    ),
                    SizedBox(height: 16.0),
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
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Color(0XFFEBEFF2),
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
          SizedBox(height: 8.0),
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
