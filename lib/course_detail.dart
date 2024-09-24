import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mycourse.dart';
import 'login.dart'; // 로그인 화면
import 'review.dart'; // 리뷰 페이지
import 'package:http/http.dart' as http;
import 'booking_done.dart';

class MountainDetailPage extends StatefulWidget {
  final int courseId;
  final String information;
  final String mountainName;
  final String courseName;
  final String distance;
  final String duration;
  final String difficulty;
  final String altitude;
  final String courseImage;

  MountainDetailPage({
    required this.courseId,
    required this.courseImage,
    required this.mountainName,
    required this.information,
    required this.courseName,
    required this.distance,
    required this.duration,
    required this.difficulty,
    required this.altitude,
  });

  @override
  _MountainDetailPageState createState() => _MountainDetailPageState();
}

class _MountainDetailPageState extends State<MountainDetailPage> {
  bool isLoading = false;
  bool isLoggedIn = false;
  final String _url = 'http://43.203.197.86:8080';
  Map<String, dynamic>? weatherData;
  List<dynamic> restaurantData = [];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // 처음 페이지가 로드되면 로그인 상태를 확인
    _fetchWeatherData();
    _fetchRestaurantData();
  }

  //날씨 api
  Future<void> _fetchWeatherData() async {
    setState(() {
      isLoading = true;
    });
    final url = _url + '/api/weather/getInfo/${widget.mountainName}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          weatherData = json.decode(response.body);
        });
      } else {
        print('Failed to fetch weather data');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  // 식당 api
  Future<void> _fetchRestaurantData() async {
    setState(() {
      isLoading = true;
    });
    final url = _url + '/api/restaurant/getInfo/${widget.courseName}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          restaurantData = json.decode(response.body);
        });
      } else {
        print('Failed to fetch restaurant data');
      }
    } catch (e) {
      print('Error fetching restaurant data: $e');
    }
  }

  // 로그인 상태를 확인하는 함수
  Future<void> _checkLoginStatus() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginMethod = prefs.getString('loginMethod');
    String? userId = prefs.getString('uid');

    if (loginMethod != null && userId != null) {
      bool isValid = await _validateToken(userId, loginMethod);
      setState(() {
        isLoggedIn = isValid;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoggedIn = false;
        isLoading = false;
      });
    }
  }

  // 토큰 유효성 확인
  Future<bool> _validateToken(String token, String loginMethod) async {
    // 서버와 토큰 유효성 검사 로직 추가 가능
    return true; // 예시로 항상 유효하다고 가정
  }

  // 예약 버튼 눌렀을 때 처리하는 함수
  Future<void> _bookCourse() async {
    if (!isLoggedIn) {
      // 로그인 상태가 아니면 로그인 화면으로 이동
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0); // 아래에서 위로 슬라이드 애니메이션
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    } else {
      // 서버에 예약 정보를 전송하는 함수 호출 (예시 코드)
      _sendBookingInfoToServer();
    }
  }

  void navigateToBookingDoneScreen() async {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BookingDoneScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.fastEaseInToSlowEaseOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  Future<void> _sendBookingInfoToServer() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('uid');
    print(userId);
    final courseName = widget.courseName;
    print(courseName);
    final url = _url + '/api/users/$userId/my-courses/$courseName';
    print(url);

    try {
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;

          navigateToBookingDoneScreen();
        });

        print('Booking information sent successfully');
      } else {
        setState(() {
          isLoading = false;
        });
        print(
            'Failed to send booking information. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error sending booking information: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(' '),
          backgroundColor: Colors.white.withOpacity(0.0),
          elevation: 0.0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 150,
              width: 330,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(widget.courseImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            TabBar(
              labelColor: Colors.black,
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pretendard',
              ),
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                fontFamily: 'Pretendard',
              ),
              indicatorColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: "Information"),
                Tab(text: "Restaurants"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildMountainInfoTab(context),
                  _buildNearbyRestaurantsTab(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Container(
                      width: 500,
                      height: 120,
                      child: Center(
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/alert_check.svg',
                              width: 70,
                              height: 70,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Do you want to book this course?',
                              style: TextStyle(
                                color: Color(0xff555a5c),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: TextButton(
                              child: Text(
                                'Cancel',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          SizedBox(width: 50),
                          Container(
                            child: TextButton(
                              child: Text(
                                'Booking',
                                style: TextStyle(
                                    color: Color(0xff1dbe9c), fontSize: 16),
                              ),
                              onPressed: () async {
                                await _bookCourse();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              )
            },
            child: Text('Booking',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0XFF1DBE92),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMountainInfoTab(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.directions_walk, color: Colors.grey),
                SizedBox(width: 8),
                Text('Hiking',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontFamily: 'Pretendard')),
                SizedBox(width: 16),
                Icon(Icons.location_on, color: Colors.grey),
                SizedBox(width: 8),
                Text(widget.mountainName,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontFamily: 'Pretendard')),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  widget.courseName.replaceAll('_', ' '),
                  style: TextStyle(
                    fontSize: widget.courseName.length > 28 ? 20 : 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard',
                    color: Color(0xff1dbe92),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              widget.information,
              style: TextStyle(
                color: Color(0xff555a5c),
                fontSize: 12,
                fontFamily: 'Pretendard',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoChip('Level', widget.difficulty),
                _buildInfoChip('Time', widget.duration),
                _buildInfoChip('Distance', widget.distance),
                _buildInfoChip('Altitude', widget.altitude + " m"),
              ],
            ),
            SizedBox(height: 30),
            Text('Weather Forecast',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard')),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFFF5F7F8),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeatherItem(
                      weatherData?['condition'] == '흐림'
                          ? 'assets/cloud.svg'
                          : weatherData?['condition'] == '맑음'
                              ? 'assets/sun.svg'
                              : weatherData?['condition'] == '비'
                                  ? 'assets/rain.svg'
                                  : weatherData?['condition'] == '눈'
                                      ? 'assets/snow.svg'
                                      : 'assets/cloud.svg',
                      weatherData?['forecastDate'] ?? '',
                      '${weatherData?['temperature'] ?? ''}°',
                      '${weatherData?['predictRain'] ?? ''}%'),
                  _buildWeatherItem(
                      weatherData?['condition'] == '흐림'
                          ? 'assets/cloud.svg'
                          : weatherData?['condition'] == '맑음'
                              ? 'assets/sun.svg'
                              : weatherData?['condition'] == '비'
                                  ? 'assets/rain.svg'
                                  : weatherData?['condition'] == '눈'
                                      ? 'assets/snow.svg'
                                      : 'assets/cloud.svg',
                      weatherData?['forecastDate1'] ?? '',
                      '${weatherData?['temperature1'] ?? ''}°',
                      '${weatherData?['predictRain1'] ?? ''}%'),
                  _buildWeatherItem(
                      weatherData?['condition'] == '흐림'
                          ? 'assets/cloud.svg'
                          : weatherData?['condition'] == '맑음'
                              ? 'assets/sun.svg'
                              : weatherData?['condition'] == '비'
                                  ? 'assets/rain.svg'
                                  : weatherData?['condition'] == '눈'
                                      ? 'assets/snow.svg'
                                      : 'assets/cloud.svg',
                      weatherData?['forecastDate2'] ?? '',
                      '${weatherData?['temperature2'] ?? ''}°',
                      '${weatherData?['predictRain2'] ?? ''}%'),
                  _buildWeatherItem(
                      weatherData?['condition'] == '흐림'
                          ? 'assets/cloud.svg'
                          : weatherData?['condition'] == '맑음'
                              ? 'assets/sun.svg'
                              : weatherData?['condition'] == '비'
                                  ? 'assets/rain.svg'
                                  : weatherData?['condition'] == '눈'
                                      ? 'assets/snow.svg'
                                      : 'assets/cloud.svg',
                      weatherData?['forecastDate3'] ?? '',
                      '${weatherData?['temperature3'] ?? ''}°',
                      '${weatherData?['predictRain3'] ?? ''}%'),
                  _buildWeatherItem(
                      weatherData?['condition'] == '흐림'
                          ? 'assets/cloud.svg'
                          : weatherData?['condition'] == '맑음'
                              ? 'assets/sun.svg'
                              : weatherData?['condition'] == '비'
                                  ? 'assets/rain.svg'
                                  : weatherData?['condition'] == '눈'
                                      ? 'assets/snow.svg'
                                      : 'assets/cloud.svg',
                      weatherData?['forecastDate4'] ?? '',
                      '${weatherData?['temperature4'] ?? ''}°',
                      '${weatherData?['predictRain4'] ?? ''}%'),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Location',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard'),
            ),
            SizedBox(height: 20),
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: FlutterMap(
                options: MapOptions(
                  initialZoom: 10,
                  minZoom: 10,
                  maxZoom: 12,
                  initialCenter: LatLng(38.1195, 128.4656),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://api.mapbox.com/styles/v1/suzzinova/cm0e0akh400xh01ps9yvn19ek/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic3V6emlub3ZhIiwiYSI6ImNtMDFvYW5jZjA0djUycnEzYTQ3ZnYwZ2MifQ._fiK5XHOO8_j1uFBrfK__g",
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(38.1195, 128.4656),
                        width: 80,
                        height: 80,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Required Equipment',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEquipmentIcon('Outer'),
                _buildEquipmentIcon('Stick'),
                _buildEquipmentIcon('Shoes'),
                _buildEquipmentIcon('Water'),
                _buildEquipmentIcon('Energy'),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Safety Management and Emergency Preparedness',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard'),
            ),
            SizedBox(height: 20),
            Text(
              'Ensure you are well-prepared before heading into the mountains. Carry essential safety gear, stay informed about weather conditions, and always follow marked trails. In case of an emergency, remain calm, use your emergency kit, and contact local authorities or emergency services for assistance.',
              style: TextStyle(
                color: Color(0xff555a5c),
                fontSize: 12,
                fontFamily: 'Pretendard',
              ),
            ),
            SizedBox(height: 30),
            Text('Reviews',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard')),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Johnson',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '2024.08.06',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.green, size: 16),
                      Icon(Icons.star, color: Colors.green, size: 16),
                      Icon(Icons.star, color: Colors.green, size: 16),
                      Icon(Icons.star, color: Colors.green, size: 16),
                      Icon(Icons.star_half, color: Colors.green, size: 16),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This is a great mountain to hike. The views are amazing and the trails are well-maintained. I would definitely recommend it to anyone looking for a challenging hike with beautiful scenery.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff555a5c),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'View All Reviews >',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFFE0E0E0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherItem(
      String iconPath, String date, String temperature, String precipitation) {
    return Column(
      children: [
        Text(
          date,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontFamily: 'Pretendard',
          ),
        ),
        SizedBox(height: 8.0),
        SvgPicture.asset(
          iconPath,
          height: 32,
          width: 32,
          color: Colors.grey,
        ),
        SizedBox(height: 8.0),
        Text(
          temperature,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pretendard',
            color: Colors.black,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          precipitation,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Pretendard',
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyRestaurantsTab() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.transparent,
          elevation: 0,
          child: ListTile(
            leading: Container(
              width: 60,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: restaurantData[index]['imageUrl1'] != ''
                    ? Image.network(
                        restaurantData[index]['imageUrl1'],
                        fit: BoxFit.cover,
                      )
                    : Image.asset('assets/mo.png'),
              ),
            ),
            minVerticalPadding: 16,
            title: Text(restaurantData[index]['restaurant_name'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard',
                )),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.grey, size: 10),
                    SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        restaurantData[index]['address'],
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Pretendard',
                        ),
                        overflow: TextOverflow.visible, // 텍스트를 줄 바꿈 없이 표시
                        softWrap: true, // 자동 줄바꿈을 허용
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(children: [
                  Icon(
                    Icons.phone,
                    color: Colors.grey,
                    size: 10,
                  ),
                  SizedBox(width: 5),
                  Text(
                    restaurantData[index]['tel'] != ''
                        ? restaurantData[index]['tel']
                        : 'none',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Column(
      children: [
        Container(
          width: 82,
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFFECF0F2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Color(0xFF858C90),
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 0.10,
                ),
              ),
              SizedBox(height: 20),
              Text(
                value,
                style: TextStyle(
                  color: Color(0xFF242729),
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                  height: 0.10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentIcon(String label) {
    return Column(
      children: [
        SvgPicture.asset('assets/$label.svg'),
        SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF1d2228),
            fontSize: 12,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            height: 0.10,
          ),
        ),
      ],
    );
  }
}
