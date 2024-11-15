import 'dart:convert'; // JSON 인코딩을 위해 필요
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'search.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'loading.dart';
import 'course_detail.dart';

class AppConstants {
  static const String naverClientId = 'uiu5p4m0nb'; // 네이버맵 Client ID
  static final NLatLng kangwondoCenter =
      NLatLng(37.5550, 128.2098); // 강원도 중심 좌표
}

class Treking extends StatefulWidget {
  @override
  _Treking createState() => _Treking();
}

class _Treking extends State<Treking> {
  final String _url = 'http://43.203.197.86:8080';
  final List<Map<String, dynamic>> mountainData = [
    {
      'name': 'Seoraksan',
      'location': NLatLng(38.12016, 128.4657),
    },
    {
      'name': 'Odaesan',
      'location': NLatLng(37.79815, 128.5430),
    },
    {
      'name': 'Chiaksan',
      'location': NLatLng(37.37172, 128.0505),
    },
    {'name': 'Taebaeksan', 'location': NLatLng(37.0957536, 128.9152435)},
    {'name': 'Dutasan', 'location': NLatLng(37.26003, 129.1000)},
    {'name': 'Myeongseongsan', 'location': NLatLng(38.10780, 127.3404)},
    {'name': 'Jeombongsan', 'location': NLatLng(38.04930, 128.4253)},
    {'name': 'Hwangbyeongsan', 'location': NLatLng(37.75783, 128.6634)},
    {'name': 'Daeamsan', 'location': NLatLng(38.21123, 128.1351)},
    {'name': 'Garisan', 'location': NLatLng(37.87344, 127.9609)},
    {'name': 'Gariwangsan', 'location': NLatLng(37.46250, 128.5634)},
    {'name': 'Gyebangsan', 'location': NLatLng(37.72831, 128.4655)},
    {'name': 'Gongjaksan', 'location': NLatLng(37.71566, 128.0100)},
    {'name': 'Baekunsan', 'location': NLatLng(37.29616, 127.9586)},
    {'name': 'Bangtaesan', 'location': NLatLng(37.89488, 128.3560)},
    {'name': 'Baekdeoksan', 'location': NLatLng(37.39657, 128.2934)},
    {'name': 'Samaksan', 'location': NLatLng(37.83991, 127.6603)},
    {'name': 'Obongsan', 'location': NLatLng(38.00078, 127.8061)},
    {'name': 'Yonghwasan', 'location': NLatLng(38.03942, 127.7438)},
    {'name': 'Eungbongsan', 'location': NLatLng(38.1017, 127.57)},
    {'name': 'Taehwasan', 'location': NLatLng(37.4003, 127.5822)},
    {'name': 'Palbongsan', 'location': NLatLng(37.70287, 127.7540)},
    {'name': 'Deokhangsan', 'location': NLatLng(37.30891, 129.0117)}
  ];

  NaverMapController? _naverMapController;
  bool isLoading = false;
  List<Map<String, dynamic>> _selectedMountainCourses = [];
  NLatLng? _selectedMountainLocation; // 선택된 산의 위치를 저장할 변수
  String _selectedMountainName = ''; // 선택된 산의 이름을 저장할 변수
  final TextEditingController _searchController = TextEditingController();

  // 네비게이션 클릭 전에 로그인 상태 확인 함수
  Future<bool> _checkLoginBeforeNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginMethod = prefs.getString('loginMethod');
    String? token = prefs.getString('token');

    return (loginMethod != null && token != null);
  }

  // 서버에서 코스 데이터를 불러오는 함수
  Future<void> _fetchCoursesForMountain(
      String mountainName, NLatLng location) async {
    setState(() {
      _selectedMountainLocation = location; // 선택된 산의 위치 저장
    });

    try {
      final response = await http.get(
        Uri.parse(
            _url + '/api/courses/getCourse/${mountainName}'), // 서버 API URL
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        setState(() {
          _selectedMountainCourses =
              List<Map<String, dynamic>>.from(responseData['courses']);
          print(responseData);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load courses")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading courses: $e")),
      );
    }

    // 데이터 로딩이 완료된 후에 카메라가 선택된 위치로 이동하도록 처리
    if (_selectedMountainLocation != null && !isLoading) {
      final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
        target: _selectedMountainLocation!,
        zoom: 12,
      );
      cameraUpdate.setAnimation(
          animation: NCameraAnimation.easing, duration: Duration(seconds: 2));
      _naverMapController?.updateCamera(cameraUpdate);
    }
  }

  // 마커 클릭 시 코스 정보를 가져오는 함수
  void _onMarkerTap(String mountainName, NLatLng location) {
    setState(() {
      _selectedMountainName = mountainName;
    });

    final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
      target: location,
      zoom: 12, // 마커에 좀 더 가까이 줌인
    );
    cameraUpdate.setAnimation(
        animation: NCameraAnimation.easing, duration: Duration(seconds: 2));
    _naverMapController?.updateCamera(cameraUpdate);
  }

  // Search 버튼을 눌렀을 때 SearchPage 호출
  Future<void> _onSearchButtonPressed() async {
    final selectedMountain = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SearchPage(
          mountainData: mountainData,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // 아래에서 위로 올라오게
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );

    if (selectedMountain != null) {
      // 선택된 산의 위치로 이동
      final mountainLocation = selectedMountain['location'];
      final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
        target: mountainLocation,
        zoom: 12,
      );
      cameraUpdate.setAnimation(
          animation: NCameraAnimation.easing, duration: Duration(seconds: 2));
      _naverMapController?.updateCamera(cameraUpdate);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingScreen();
    } else {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leadingWidth: 0.0,
          leading: Container(),
          title: Column(
            children: [
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          _onSearchButtonPressed(), // 버튼 클릭 시 SearchPage 호출
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6.0,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.black),
                            SizedBox(width: 10.0),
                            Text(
                              'Search',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
            NaverMap(
              options: const NaverMapViewOptions(
                  rotationGesturesEnable: false,
                  initialCameraPosition: NCameraPosition(
                      target: NLatLng(38.1195, 128.4656), // 초기 맵 위치
                      zoom: 9,
                      bearing: 0,
                      tilt: 0),
                  mapType: NMapType.satellite,
                  activeLayerGroups: [
                    NLayerGroup.building,
                    NLayerGroup.transit,
                    NLayerGroup.mountain
                  ],
                  scrollGesturesFriction: 0.0,
                  zoomGesturesFriction: 0.0,
                  rotationGesturesFriction: 0.0,
                  minZoom: 8, // default is 0
                  maxZoom: 16, // default is 21
                  extent: NLatLngBounds(
                    southWest: NLatLng(33.0, 124.0),
                    northEast: NLatLng(43.0, 132.0),
                  ),
                  locale: Locale('en', 'US')), // 지도 옵션을 설정할 수 있습니다.
              onMapReady: (controller) {
                _naverMapController = controller;

                // 마커 추가 및 클릭 리스너 설정
                for (var mountain in mountainData) {
                  final marker = NMarker(
                    id: mountain['name'],
                    position: mountain['location'],
                    caption: NOverlayCaption(text: mountain['name']),
                    icon: NOverlayImage.fromAssetImage('assets/mark.png'),
                  );

                  // 마커 클릭 리스너 추가
                  marker.setOnTapListener((NMarker marker) {
                    _fetchCoursesForMountain(
                        marker.info.id, mountain['location']);
                    _onMarkerTap(marker.info.id,
                        mountain['location']); // 마커를 클릭 시 해당 산 정보를 가져옴
                    return true; // 마커 클릭 이벤트 소비
                  });

                  _naverMapController!.addOverlay(marker);
                }
              },
              onMapTapped: (point, latLng) {},
              onSymbolTapped: (symbol) {},
              onCameraChange: (position, reason) {},
              onCameraIdle: () {},
              onSelectedIndoorChanged: (indoor) {},
              forceGesture:
                  false, // 지도에 전달되는 제스처 이벤트의 우선순위를 가장 높게 설정할지 여부를 지정합니다.
            ),
            if (_selectedMountainCourses.isNotEmpty)
              Positioned(
                bottom: 30.0,
                left: 0,
                right: 0,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    enlargeCenterPage: false,
                    autoPlay: false,
                    viewportFraction: 0.82,
                    enableInfiniteScroll: false, // 무한 스크롤 비활성화
                  ),
                  items: _selectedMountainCourses.map((course) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        MountainDetailPage(
                                  courseId: course['courseId'],
                                  courseImage: course['courseImage'],
                                  courseName: course['courseName'],
                                  information: course['information'] ?? '',
                                  mountainName: _selectedMountainName,
                                  distance: course['distance'],
                                  duration: course['duration'],
                                  difficulty: course['difficulty'],
                                  altitude: course['altitude'],
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin =
                                      Offset(0.0, 1.0); // 아래에서 위로 올라오게
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
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height *
                                0.7, // Updated height
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
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: course['courseImage'],
                                    width: 230,
                                    height: 100,
                                    fit: BoxFit.fitWidth,
                                    placeholder: (context, url) => Container(
                                      width: 230,
                                      height: 100,
                                      color: Colors.grey[100],
                                      child: Center(
                                        child: LoadingScreen(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
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
                                      course['courseName'].replaceAll('_', ' '),
                                      style: TextStyle(
                                        fontSize:
                                            course['courseName'].length > 28
                                                ? 14.0
                                                : 16.0,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow
                                          .ellipsis, // Optionally truncate long text
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 22,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: ShapeDecoration(
                                        color: Color(0xFFF4F6F6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                              fontSize: 10,
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
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                              fontSize: 10,
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
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                              fontSize: 10,
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
                                      width: 55,
                                      height: 22,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: ShapeDecoration(
                                        color: Color(0xFFF4F6F6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                            course['altitude'] + "m",
                                            style: TextStyle(
                                              color: Color(0xFF858C90),
                                              fontSize: 10,
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
      );
    }
  }
}
