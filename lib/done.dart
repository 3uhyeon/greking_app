import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding
import 'package:lottie/lottie.dart';
import 'package:my_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TrackingSummaryPage extends StatefulWidget {
  final double totalDistance;
  final double totalCalories;
  final double maxAltitude;
  final Duration totalTime;
  final int userCourseId;

  TrackingSummaryPage({
    required this.totalDistance,
    required this.totalCalories,
    required this.maxAltitude,
    required this.totalTime,
    required this.userCourseId,
  });

  @override
  _TrackingSummaryPageState createState() => _TrackingSummaryPageState();
}

class _TrackingSummaryPageState extends State<TrackingSummaryPage>
    with SingleTickerProviderStateMixin {
  bool _isAnimationCompleted = false;
  bool levelup = false;
  Duration _animationDuration = Duration(seconds: 1);
  late AnimationController _animationController;
  final String _url = 'http://43.203.197.86:8080'; // 서버 URL 입력
  @override
  void initState() {
    super.initState();
    _startSummaryAnimation();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // 애니메이션 완료 시 서버로 데이터를 전송하는 함수
  void _startSummaryAnimation() {
    Future.delayed(_animationDuration, () {
      setState(() {
        _isAnimationCompleted = true;
      });
    });
  }

  // 서버로 데이터 전송
  Future<void> _sendSummaryToServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('uid');

    try {
      final response = await http.post(
        Uri.parse(_url +
            '/api/users/${userId}/my-courses/${widget.userCourseId}/complete'), // 서버 URL 입력
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "distance": widget.totalDistance,
          "calories": widget.totalCalories,
          "altitude": widget.maxAltitude,
          "duration": widget.totalTime.toString(),
        }),
      );

      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['levelUp']);
        if (jsonDecode(response.body)['levelUp']) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Stack(
                  children: [
                    RotationTransition(
                      turns: _animationController,
                      child: SvgPicture.asset(
                        'assets/level_round.svg',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/level${jsonDecode(response.body)['now_level']}.svg',
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Thank you'),
                  ),
                ],
              );
            },
          );
        }
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) => MainPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
        print('Data sent to server successfully!');
      } else {
        print('Failed to send data to server!');
      }
    } catch (e) {
      print('Error sending data to server: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          leading: Container(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/done.json', repeat: false),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.place),
                  SizedBox(width: 5),
                  _buildAnimatedCounter("Distance", widget.totalDistance, "km"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_run_sharp),
                  SizedBox(width: 5),
                  _buildAnimatedCounter(
                      "Calories", widget.totalCalories, "kcal"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.filter_hdr_sharp),
                  SizedBox(width: 5),
                  _buildAnimatedCounter("Altitude", widget.maxAltitude, "m"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timer),
                  SizedBox(width: 5),
                  _buildAnimatedTimeCounter("Time", widget.totalTime),
                ],
              ),
              SizedBox(height: 20),
              if (_isAnimationCompleted)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff1dbe92),
                    minimumSize: Size(double.infinity, 40),
                  ),
                  onPressed: () {
                    _sendSummaryToServer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'Check my progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // 거리, 고도, 칼로리용 애니메이션 빌더
  Widget _buildAnimatedCounter(String label, double targetValue, String unit) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: targetValue),
      duration: _animationDuration,
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    "$label:",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(width: 5),
                  Text(' ${value.toStringAsFixed(1)} $unit',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1dbe92))),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // 시간용 애니메이션 빌더
  Widget _buildAnimatedTimeCounter(String label, Duration targetDuration) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: targetDuration.inSeconds.toDouble()),
      duration: _animationDuration,
      builder: (context, value, child) {
        final time = Duration(seconds: value.toInt());
        String formattedTime = _formatDuration(time);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    "$label: ",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '$formattedTime',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1dbe92)),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // 시간 형식 변환 함수
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
