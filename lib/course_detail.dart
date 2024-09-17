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
  final String courseId;
  final String mountainName;
  final String courseName;
  final String distance;
  final String duration;
  final String difficulty;
  final String altitude;

  MountainDetailPage({
    required this.courseId,
    required this.mountainName,
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

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // 처음 페이지가 로드되면 로그인 상태를 확인
  }

  // 로그인 상태를 확인하는 함수
  Future<void> _checkLoginStatus() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginMethod = prefs.getString('loginMethod');
    String? token = prefs.getString('token');

    if (loginMethod != null && token != null) {
      bool isValid = await _validateToken(token, loginMethod);
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
      // 로그인 상태면 예약 페이지로 이동하고 서버로 예약 정보 전달
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyCourse(), // 예약 페이지로 이동
        ),
      );
    }
  }

  Future<void> _sendBookingInfoToServer() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    final courseName = widget.courseName;
    final url =
        'http://localhost:8080/api/users/$userId/my-courses/$courseName';

    try {
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  BookingDoneScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.fastEaseInToSlowEaseOut;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          );
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
              height: 200,
              width: 330,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/mo.png'),
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
            onPressed: _bookCourse, // 예약 버튼 클릭 시 호출
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
                Text('Gangwon-do, South Korea',
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
                  widget.mountainName,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard',
                      color: Color(0xff1dbe92)),
                ),
                SizedBox(width: 8),
                Text(
                  widget.courseName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Seoraksan National Park is one of South Korea\'s most famous and beautiful natural parks, located in the northeastern part of the country. It offers a variety of hiking trails that cater to different skill levels, ranging from easy walks to challenging climbs. The most popular trails include the Ulsanbawi Rock trail, known for its panoramic views, and the Biryong Falls trail, which leads to a stunning waterfall. For more experienced hikers, the Daecheongbong Peak trail is a must, as it takes you to the park\'s highest point at 1,708 meters, offering breathtaking views of the surrounding mountains and valleys. Seoraksan is particularly famous for its autumn foliage, which attracts numerous visitors each year.',
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
                _buildInfoChip('Altitude', widget.altitude),
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
                      'assets/cloud.svg', '7.27', 'Saturday', '27°', '10%'),
                  _buildWeatherItem(
                      'assets/sun.svg', '7.28', 'Sunday', '25°', '00%'),
                  _buildWeatherItem(
                      'assets/rain.svg', '7.29', 'Monday', '26°', '50%'),
                  _buildWeatherItem(
                      'assets/snow.svg', '7.30', 'Thuesday', '27°', '10%'),
                  _buildWeatherItem(
                      'assets/thunder.svg', '7.31', 'Wendsday', '26°', '60%'),
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
                _buildEquipmentIcon('Equipment1'),
                _buildEquipmentIcon('Equipment2'),
                _buildEquipmentIcon('Equipment3'),
                _buildEquipmentIcon('Equipment4'),
                _buildEquipmentIcon('Equipment5'),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ReviewPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                            position: offsetAnimation, child: child);
                      },
                    ),
                  );
                },
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

  Widget _buildWeatherItem(String iconPath, String date, String day,
      String temperature, String precipitation) {
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
        SizedBox(height: 3.0),
        Text(day,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontFamily: 'Pretendard',
            )),
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
                child: Image.asset(
                  'assets/mo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            minVerticalPadding: 16,
            title: Text('Suhyeon sikdang',
                style: TextStyle(
                  fontSize: 16,
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
                    Text(
                      '  서울시 성북구 솔샘로16길 31-5',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Pretendard',
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
                  Text(
                    '  02-1234-5678',
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
        SvgPicture.asset('assets/equipment.svg'),
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
