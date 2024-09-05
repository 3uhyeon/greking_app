import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:gpx/gpx.dart';
import 'dart:async';

class TrackingPage extends StatefulWidget {
  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class AppConstants {
  static const String mapBoxAccessToken =
      'sk.eyJ1Ijoic3V6emlub3ZhIiwiYSI6ImNtMDUyOW54bzBiaDkya3NiNGdhbjVqeDgifQ.nvB1cGwKQEgxdlqGWe-hQw';
  static const String mapBoxStyleId = 'suzzinova';

  static final LatLng kangwondoCenter = LatLng(37.5550, 128.2098);
}

class _TrackingPageState extends State<TrackingPage> {
  late MapController _mapController;
  StreamSubscription<Position>? _positionStream;
  final List<LatLng> _routePoints = [];
  final List<Marker> _markers = [];
  double _totalDistance = 0.0;
  double _totalCalories = 0.0;
  Duration _totalTime = Duration.zero;
  Timer? _timer;
  bool _isTracking = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _loadGpxFile();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _timer?.cancel();
    super.dispose();
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

    _startTracking(); // 위치 권한이 허용되었을 때만 추적 시작
  }

  Future<void> _loadGpxFile() async {
    String gpxData = await DefaultAssetBundle.of(context)
        .loadString('assets/chiaksan_0000000001.gpx');
    final gpx = GpxReader().fromString(gpxData);

    setState(() {
      _routePoints.addAll(gpx.trks[0].trksegs[0].trkpts.map((pt) {
        return LatLng(pt.lat!, pt.lon!);
      }));

      if (_routePoints.isNotEmpty) {
        _markers.add(
          Marker(
            point: _routePoints.first,
            child:
                SvgPicture.asset('assets/dot.svg', width: 40.0, height: 40.0),
          ),
        );

        _markers.add(
          Marker(
            point: _routePoints.last,
            child:
                SvgPicture.asset('assets/dot.svg', width: 40.0, height: 40.0),
          ),
        );

        // 페이지 로드 시 초기 줌 레벨을 12.5로 설정
        final middlePoint = LatLng(
          (_routePoints.first.latitude + _routePoints.last.latitude) / 2,
          (_routePoints.first.longitude + _routePoints.last.longitude) / 2,
        );
        _mapController.move(middlePoint, 12.5);
      }
    });
  }

  void _startTracking() {
    setState(() {
      _isTracking = true;
      _totalTime = Duration.zero;

      if (_routePoints.isNotEmpty) {
        // Start 버튼을 눌렀을 때 줌 레벨을 15로 변경
        _mapController.move(_routePoints.first, 15.0);
      }
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _totalTime += Duration(seconds: 1);
      });
    });

    _positionStream =
        Geolocator.getPositionStream().listen((Position position) {
      final currentPoint = LatLng(position.latitude, position.longitude);
      if (_routePoints.isNotEmpty) {
        final lastPoint = _routePoints.last;

        setState(() {
          _routePoints.add(currentPoint);
          _totalDistance += Geolocator.distanceBetween(
                lastPoint.latitude,
                lastPoint.longitude,
                currentPoint.latitude,
                currentPoint.longitude,
              ) /
              1000;
          _totalCalories = _calculateCalories(_totalDistance);
        });
      } else {
        setState(() {
          _routePoints.add(currentPoint);
          _markers.add(Marker(
            point: currentPoint,
            child: Icon(
              Icons.location_on,
              color: Colors.green,
              size: 40.0,
            ),
          ));
        });
      }
    });
  }

  double _calculateCalories(double distance) {
    return distance * 60;
  }

  void _stopTracking() {
    setState(() {
      _isTracking = false;
    });
    _positionStream?.cancel();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking',
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/suzzinova/cm054z5r000i201rbdvg243vw/tiles/256/{z}/{x}/{y}@2x?access_token=${AppConstants.mapBoxAccessToken}",
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 8.0,
                      color: Color(0xff0d615c),
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: _markers,
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: Container(
              height: 420,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(
                              0xff1dbe92), // Change background color to blue
                          minimumSize: Size(122, 44), // Change width and height
                        ),
                      ),
                      SizedBox(width: 170.0),
                      SvgPicture.asset('assets/sos.svg'),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoCard('Distance',
                          '${_totalDistance.toStringAsFixed(2)} km'),
                      _buildInfoCard('Altitude', 'N/A'),
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
                  SizedBox(height: 26.0),
                  ElevatedButton(
                    onPressed:
                        _isTracking ? _stopTracking : _checkLocationPermission,
                    child: Text(_isTracking ? 'Pause' : 'Start',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xff1dbe92), // Change background color to blue
                      minimumSize: Size(292, 56), // Change width and height
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      width: 168,
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
          SizedBox(height: 8.0),
          Text(value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
