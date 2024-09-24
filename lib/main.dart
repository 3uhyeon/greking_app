import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/gpx_treking.dart';
import 'package:my_app/question.dart';
import 'package:my_app/review_detail.dart';
import 'package:my_app/review_write.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'loading.dart';
import 'map.dart';
import 'shop.dart';
import 'mypage.dart';
import 'mycourse.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'question.dart';
import 'package:lottie/lottie.dart';
import 'review_detail.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'article.dart';
import 'review_write.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: 'uiu5p4m0nb');
  // Flutter Background 초기화
  await FlutterBackground.initialize();
  // Firebase 초기화
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        name: 'greking',
        options: FirebaseOptions(
          apiKey: 'key',
          appId: '1:1061154392257:android:62346b5a1fe5a243ef2c40',
          messagingSenderId: 'sendid',
          projectId: 'greking-8e95f',
          storageBucket: 'greking-8e95f.appspot.com',
        ));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        title: 'Greking App',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.grey[100]),
        home: const MainPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  bool isLoading = false;
  bool isLoggedIn = false;
  final PageController _pageController = PageController();
  final PageController _pageController2 = PageController();
  List<Map<String, dynamic>> _recommendCourses = [
    {
      "mountainName": "Seoraksan",
      "courseName": "Daecheongbong_Course",
      "courseImage":
          "https://jinhyuk.s3.ap-northeast-2.amazonaws.com/daechung_good.webp"
    },
    {
      "mountainName": "Seoraksan",
      "courseName": "Suryeomdong_Course",
      "courseImage":
          "https://jinhyuk.s3.ap-northeast-2.amazonaws.com/Suryeomdong_Course.webp"
    },
    {
      "mountainName": "Odaesan",
      "courseName": "Sangwangbong_Course",
      "courseImage":
          "https://jinhyuk.s3.ap-northeast-2.amazonaws.com/Sangwangbong_Course.webp"
    },
    {
      "mountainName": "Dutasan",
      "courseName": "Cheoneunsa_Temple_Course",
      "courseImage":
          "https://jinhyuk.s3.ap-northeast-2.amazonaws.com/duta_good.webp"
    },
    {
      "mountainName": "Taehwaksan",
      "courseName": "Bukbyeok_Bridge_Course",
      "courseImage":
          "https://jinhyuk.s3.ap-northeast-2.amazonaws.com/Bukbyeok_Bridge_Course.webp"
    }
  ];
  int _currentIndex = 0;
  final String _url = 'http://43.203.197.86:8080';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _checkRecommendCourse();
  }

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

  Future<void> _checkRecommendCourse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('uid');
    setState(() {
      isLoading = true;
    });
    if (userId == null) {
      return;
    }
    // API 요청 보내기
    var response = await http.get(
      Uri.parse(_url + '/api/recommend/${userId}'), // 서버 URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _recommendCourses = List<Map<String, dynamic>>.from(data);
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> _validateToken(String userId, String loginMethod) async {
    return true;
  }

  void _onPageChanged(int index) async {
    if (index == 2 && !await _checkLoginBeforeNavigate()) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.fastEaseInToSlowEaseOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      ).then((_) {
        _pageController.jumpToPage(0);
      });
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Future<void> _onItemTapped(int index) async {
    if (index == 2 && !await _checkLoginBeforeNavigate()) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.fastEaseInToSlowEaseOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    } else {
      _pageController.jumpToPage(index);
    }
  }

  Future<bool> _checkLoginBeforeNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginMethod = prefs.getString('loginMethod');
    String? userId = prefs.getString('uid');
    return (loginMethod != null && userId != null);
  }

  PreferredSizeWidget _buildAppBar() {
    switch (_currentIndex) {
      case 0:
        return AppBar(
          leadingWidth: 200,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Row(
            children: [
              SizedBox(width: 16.0),
              Text(
                '  Greking',
                style: TextStyle(
                  color: Color(0xff0d615c),
                  fontSize: 24,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      case 1:
        return AppBar(
          leadingWidth: 200,
          leading: Row(
            children: [
              SizedBox(width: 16.0),
              Text(
                '  Map',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor:
              Colors.transparent, // Set the background color to transparent
          elevation: 0, // Remove the shadow
        );
      case 2:
        return AppBar(
          leadingWidth: 200,
          backgroundColor: Colors.white.withOpacity(0.0),
          elevation: 0,
          leading: Row(
            children: [
              SizedBox(width: 16.0),
              Text(
                '  My Course',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      case 3:
        return AppBar(
          leadingWidth: 200,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Row(
            children: [
              SizedBox(width: 16.0),
              Text(
                '  Rental Service',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      case 4:
        return AppBar(
          leadingWidth: 200,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Row(
            children: [
              SizedBox(width: 16.0),
              Text(
                '  MyPage',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      default:
        return AppBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingScreen();
    } else {
      return WillPopScope(
        onWillPop: () async => false, // Disable back button
        child: Scaffold(
          appBar: _buildAppBar(),
          body: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(), // Disable scrolling
            onPageChanged: _onPageChanged,
            children: [
              _buildHomePage(),
              Treking(),
              MyCourse(),
              Shop(),
              My(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(_currentIndex == 0
                    ? 'assets/navi_home_on.svg'
                    : 'assets/navi_home_off.svg'),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(_currentIndex == 1
                    ? 'assets/navi_second_on.svg'
                    : 'assets/navi_second_off.svg'),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(_currentIndex == 2
                    ? 'assets/navi_third_on.svg'
                    : 'assets/navi_third_off.svg'),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(_currentIndex == 3
                    ? 'assets/navi_four_on.svg'
                    : 'assets/navi_four_off.svg'),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(_currentIndex == 4
                    ? 'assets/navi_five_on.svg'
                    : 'assets/navi_five_off.svg'),
                label: '',
              ),
            ],
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
          ),
        ),
      );
    }
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 100,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
              ),
              items: [1, 2, 3].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            switch (i) {
                              case 1:
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        ArticleMainPage1(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(0.0, -1.0);
                                      const end = Offset.zero;
                                      const curve =
                                          Curves.fastEaseInToSlowEaseOut;
                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
                                      var offsetAnimation =
                                          animation.drive(tween);

                                      return SlideTransition(
                                          position: offsetAnimation,
                                          child: child);
                                    },
                                  ),
                                );
                                break;
                              case 2:
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        ArticleMainPage2(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(0.0, -1.0);
                                      const end = Offset.zero;
                                      const curve =
                                          Curves.fastEaseInToSlowEaseOut;
                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
                                      var offsetAnimation =
                                          animation.drive(tween);

                                      return SlideTransition(
                                          position: offsetAnimation,
                                          child: child);
                                    },
                                  ),
                                );
                                break;

                              case 3: //ArticleMainPage3을 제거함
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        ArticleMainPage4(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(0.0, -1.0);
                                      const end = Offset.zero;
                                      const curve =
                                          Curves.fastEaseInToSlowEaseOut;
                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
                                      var offsetAnimation =
                                          animation.drive(tween);

                                      return SlideTransition(
                                          position: offsetAnimation,
                                          child: child);
                                    },
                                  ),
                                );
                                break;
                              // Add more cases for other title numbers and corresponding pages
                              default:
                                break;
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage('assets/title$i.png'),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 10.0, // 왼쪽으로 더 가도록 조정
                          bottom: 10.0,

                          child: Container(
                            height: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                '$i/3',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            alignment: Alignment.bottomRight,
                          ),
                        )
                      ],
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              '  Recommend course',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            CarouselSlider(
              options: CarouselOptions(
                height: 330,
                viewportFraction: 0.8,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 4),
              ),
              items: [
                for (int i = 1; i <= (_recommendCourses.length - 5); i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: _recommendCourses[i - 1]['courseImage'],
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => LoadingScreen(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        Positioned(
                          top: 250,
                          left: 10,
                          child: Container(
                            height: 70,
                            width: 248,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.black.withOpacity(0.5),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _recommendCourses[i - 1]['mountainName'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _recommendCourses[i - 1]['courseName']
                                      .replaceAll('_', ' '),
                                  style: const TextStyle(
                                    color: Color(0xffa9b0b5),
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '  Popular course',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 300,
                    width: 350,
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      children: [
                        Image.asset('assets/pop1.png', fit: BoxFit.fitWidth),
                        const SizedBox(height: 12),
                        Image.asset('assets/pop2.png', fit: BoxFit.fitWidth),
                        const SizedBox(height: 12),
                        Image.asset('assets/pop3.png', fit: BoxFit.fitWidth),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Stack(
              children: [
                InkWell(
                  onTap: () async {
                    final url = Uri.parse(
                      'https://ektatraveling.tp.st/5pUXIAY6',
                    );
                    if (await canLaunchUrl(url)) {
                      launchUrl(url);
                    } else {
                      // ignore: avoid_print
                      print("Can't launch $url");
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/banners.png',
                      width: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                _onItemTapped(3);
              },
              child: const Text(
                '  Rental >',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 122,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                            index: "1",
                            name: "OLA HYBRID",
                            price: "1DAY \$3",
                            description:
                                "Training set-up that can be worn up to winter",
                            imagePath: "assets/outer1.png",
                            imageDetailPath: "assets/outer1-1.png",
                            category: "outer",
                          ),
                        ),
                      );
                    },
                    child: RentalItem(index: '1'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                            index: "2",
                            name: "SURROUND jacket",
                            price: "1DAY \$3",
                            description:
                                "Applying the exterior of the mechanical stretch with a natural touch",
                            imagePath: "assets/outer2.png",
                            imageDetailPath: "assets/outer1-1.png",
                            category: "outer",
                          ),
                        ),
                      );
                    },
                    child: RentalItem(index: '2'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                            index: "3",
                            name: "ALP Professional Waterproofing",
                            price: "1DAY \$3",
                            description:
                                "It is light and fits well when professional hiking by applying C-KNIT BACKER made of Gore 3L material with excellent moisture permeability",
                            imagePath: "assets/outer3.png",
                            imageDetailPath: "assets/outer3-1.png",
                            category: "outer",
                          ),
                        ),
                      );
                    },
                    child: RentalItem(index: '3'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReviewDetailPage()),
                );
              },
              child: const Text(
                'Review >',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: 8),
            const ReviewItem(),
            const SizedBox(height: 50),
            Center(
              child: TextButton(
                onPressed: () => {},
                child: const Text(
                  ' ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RentalItem extends StatelessWidget {
  final String index;

  const RentalItem({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 124,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Image.asset(
          'assets/outer$index.png',
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}

class ReviewItem extends StatelessWidget {
  const ReviewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/image.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'what a beautiful thing that i got !',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Icon(Icons.place, size: 16, color: Colors.grey),
                    Text('  Mt. Seolark  ',
                        style:
                            TextStyle(color: Color(0xffa9b0b5), fontSize: 12)),
                    Icon(Icons.star, size: 16, color: Color(0xffa9b0b5)),
                    Icon(Icons.star, size: 16, color: Color(0xffa9b0b5)),
                    Icon(Icons.star, size: 16, color: Color(0xffa9b0b5)),
                    Icon(Icons.star, size: 16, color: Color(0xffa9b0b5)),
                    Icon(Icons.star_border, size: 16, color: Color(0xffa9b0b5)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
