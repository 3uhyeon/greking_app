import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'main.dart';
import 'course_detail.dart';
import 'shop.dart';
import 'mypage.dart';
import 'mycourse.dart';

class AppConstants {
  static const String mapBoxAccessToken =
      'sk.eyJ1Ijoic3V6emlub3ZhIiwiYSI6ImNtMDUyOW54bzBiaDkya3NiNGdhbjVqeDgifQ.nvB1cGwKQEgxdlqGWe-hQw'; // 회원가입해야 받을 수 있음
  static const String mapBoxStyleId = 'suzzinova'; // 회원가입 시 제공되는 스타일 ID

  static final LatLng kangwondoCenter = LatLng(37.5550, 128.2098); // 강원도 중심 좌표
}

class Treking extends StatefulWidget {
  @override
  _Treking createState() => _Treking();
}

class _Treking extends State<Treking> {
  final List<Map<String, dynamic>> mountainData = [
    {
      'name': 'Seoraksan',
      'location': LatLng(38.12016, 128.4657),
      'courses': [
        {
          'courseName': 'Seorak Trail',
          'distance': '10km',
          'duration': '5h',
          'difficulty': 'Hard',
          'altitude': '1,708m',
        },
        {
          'courseName': 'Ulsanbawi Trail',
          'distance': '8km',
          'duration': '4h',
          'difficulty': 'Medium',
          'altitude': '876m',
        },
      ],
    },
    {
      'name': 'Odaesan',
      'location': LatLng(37.79815, 128.5430),
      'courses': [
        {
          'courseName': 'Odaesan Ridge',
          'distance': '12km',
          'duration': '6h',
          'difficulty': 'Hard',
          'altitude': '1,563m',
        },
      ],
    },
    {
      'name': 'Chiaksan',
      'location': LatLng(37.37172, 128.0505),
      'courses': [
        {
          'courseName': 'Chiaksan Loop',
          'distance': '7km',
          'duration': '3h',
          'difficulty': 'Easy',
          'altitude': '1,288m',
        },
        {
          'courseName': 'Chiaksan Summit',
          'distance': '10km',
          'duration': '5h',
          'difficulty': 'Medium',
          'altitude': '1,288m',
        },
      ],
    },
  ];

  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();

  List<Map<String, dynamic>> _selectedMountainCourses = [];
  String _selectedMountainName = ''; // 선택된 산의 이름을 저장할 변수

  void _onMarkerTap(Map<String, dynamic> mountain) {
    setState(() {
      _selectedMountainCourses = mountain['courses'];
      _selectedMountainName = mountain['name']; // 산의 이름을 저장
    });
  }

  void _onSearch() {
    String searchTerm = _searchController.text;
    final mountain = mountainData.firstWhere(
      (mountain) => mountain['name'].contains(searchTerm),
      orElse: () => {},
    );

    if (mountain.isNotEmpty) {
      _mapController.move(mountain['location'], 10.0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mountain not found")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leadingWidth: 0.0,
        leading: Container(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0, 10.0),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10.0),
                  ),
                  onSubmitted: (_) => _onSearch(),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0.0),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              maxZoom: 12,
              minZoom: 10,
              initialZoom: 10,
              initialCenter: LatLng(38.1195, 128.4656),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/suzzinova/cm054z5r000i201rbdvg243vw/tiles/256/{z}/{x}/{y}@2x?access_token=${AppConstants.mapBoxAccessToken}",
              ),
              MarkerLayer(
                markers: mountainData.map((mountain) {
                  return Marker(
                    point: mountain['location'],
                    width: 80,
                    height: 80,
                    child: GestureDetector(
                      onTap: () => _onMarkerTap(mountain),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/mark.png',
                            width: 60,
                            height: 60,
                          ),
                          SizedBox(height: 2.0),
                          Stack(
                            children: <Widget>[
                              Text(
                                mountain['name'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 3
                                    ..color = Colors.white,
                                ),
                              ),
                              Text(
                                mountain['name'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          if (_selectedMountainCourses.isNotEmpty)
            Positioned(
              bottom: 30.0,
              left: 0,
              right: 0,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 187.0,
                  enlargeCenterPage: false,
                  autoPlay: false,
                  viewportFraction: 0.8,
                  enableInfiniteScroll: false, // 무한 스크롤 비활성화
                ),
                items: _selectedMountainCourses.map((course) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MountainDetailPage(
                                courseName: course['courseName'],
                                mountainName: _selectedMountainName,
                                distance: course['distance'],
                                duration: course['duration'],
                                difficulty: course['difficulty'],
                                altitude: course['altitude'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0.0, 10.0),
                                blurRadius: 10.0,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                  ),
                                  child: Image.asset(
                                    'assets/image.png',
                                    width: 200,
                                    height: 100,
                                    fit: BoxFit.fitWidth,
                                  )),
                              SizedBox(height: 10.0),
                              Row(
                                children: [
                                  SizedBox(width: 15.0),
                                  SvgPicture.asset('assets/gps.svg'),
                                  Text(
                                    _selectedMountainName, // 선택된 산의 이름
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey,
                                      fontFamily: 'Pretendard',
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 20.0),
                                  Text(
                                    course['courseName'],
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 65,
                                    height: 22,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: ShapeDecoration(
                                      color: Color(0xFFF4F6F6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          course['difficulty'],
                                          style: TextStyle(
                                            color: Color(0xFF858C90),
                                            fontSize: 12,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w400,
                                            height: 0.10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 7.0),
                                  Container(
                                    width: 50,
                                    height: 22,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: ShapeDecoration(
                                      color: Color(0xFFF4F6F6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          course['duration'],
                                          style: TextStyle(
                                            color: Color(0xFF858C90),
                                            fontSize: 12,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w400,
                                            height: 0.10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 7.0),
                                  Container(
                                    width: 50,
                                    height: 22,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: ShapeDecoration(
                                      color: Color(0xFFF4F6F6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          course['distance'],
                                          style: TextStyle(
                                            color: Color(0xFF858C90),
                                            fontSize: 12,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w400,
                                            height: 0.10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 7.0),
                                  Container(
                                    width: 60,
                                    height: 22,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: ShapeDecoration(
                                      color: Color(0xFFF4F6F6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          course['altitude'],
                                          style: TextStyle(
                                            color: Color(0xFF858C90),
                                            fontSize: 12,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w400,
                                            height: 0.10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
              );
              break;
            case 1:
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyCourse()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Shop()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => My()),
              );
              break;
          }
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/navi_home_off.svg'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/navi_second_on.svg'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/navi_third_off.svg'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/navi_four_off.svg'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/navi_five_off.svg'),
            label: '',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
