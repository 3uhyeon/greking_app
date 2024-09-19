import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: 'uiu5p4m0nb');

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
        ),
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
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

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

  Future<bool> _validateToken(String token, String loginMethod) async {
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
    String? token = prefs.getString('token');
    return (loginMethod != null && token != null);
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
              ),
              items: [1, 2, 3, 4].map((i) {
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
                              case 3:
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        ArticleMainPage3(),
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
                              case 4:
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
                          left: 20.0, // 왼쪽으로 더 가도록 조정
                          bottom: 30.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getTitleForIndex(i), // 슬라이드마다 다른 제목
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _getSubtitleForIndex(i), // 슬라이드마다 다른 부제목
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
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
                                '$i/4',
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
              ),
              items: [
                for (int i = 0; i < 3; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage('assets/image.png'),
                                fit: BoxFit.cover,
                              ),
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
            Center(
              child: Container(
                alignment: Alignment.center,
                height: 300,
                width: 450,
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: [
                    PopularCourseItem(index: 1),
                    const SizedBox(height: 12),
                    PopularCourseItem(index: 2),
                    const SizedBox(height: 12),
                    PopularCourseItem(index: 3),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewWritingPage(
                                userCourseId: 1,
                              )),
                    );
                  },
                  child: Image.asset('assets/banners.png',
                      width: double.infinity, fit: BoxFit.fitWidth),
                ),
                // Positioned(
                //   right: 00,
                //   bottom: 40,
                //   child: Lottie.asset('assets/insurance2.json',
                //       width: 110, height: 110),
                // )
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

  // 각 슬라이드에 맞는 제목을 반환하는 함수
  String _getTitleForIndex(int index) {
    switch (index) {
      case 1:
        return 'Train Travel Guide';
      case 2:
        return 'Incheon Airport Guide';
      case 3:
        return 'Rental Guide';
      case 4:
        return 'Beginner Hiking Tips';
      default:
        return 'Guide';
    }
  }

  // 각 슬라이드에 맞는 부제목을 반환하는 함수
  String _getSubtitleForIndex(int index) {
    switch (index) {
      case 1:
        return 'How to travel to Gangwon by train!';
      case 2:
        return 'To Gangwon :The complete guide!';
      case 3:
        return 'Make your Gangwon trip easier with rentals!';
      case 4:
        return 'Essential tips for first-time hikers in Gangwon!';
      default:
        return 'Subtitle';
    }
  }
}

class PopularCourseItem extends StatelessWidget {
  final int index;
  // 각 슬라이드에 맞는 제목을 반환하는 함수
  String _getTitleForIndex2(int index) {
    switch (index) {
      case 1:
        return 'Seoraksan';
      case 2:
        return 'Chiaksan';
      case 3:
        return 'Dutasan';

      default:
        return 'Guide';
    }
  }

  // 각 슬라이드에 맞는 부제목을 반환하는 함수
  String _getSubtitleForIndex2(int index) {
    switch (index) {
      case 1:
        return 'Daechengbong Course';
      case 2:
        return 'Birobong Course';
      case 3:
        return 'Daejae Course';

      default:
        return 'Subtitle';
    }
  }

  const PopularCourseItem({required this.index});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 342,
          height: 87,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage('assets/pop$index.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          left: 20,
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getTitleForIndex2(index), // 코스 이름
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getSubtitleForIndex2(index), // 코스 설명
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
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
      margin: const EdgeInsets.symmetric(horizontal: 4),
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
