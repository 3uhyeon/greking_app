import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'loading.dart';
import 'map.dart';
import 'shop.dart';
import 'mypage.dart';
import 'mycourse.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        name: 'greking',
        options: FirebaseOptions(
          apiKey: 'key',
          appId: '1:1061154392257:android:eaba0b8f02aed76eef2c40',
          messagingSenderId: 'sendid',
          projectId: 'greking-8e95f',
          storageBucket: 'myapp-b9yt18.appspot.com',
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
  final PageController _pageController = PageController(); // PageController 추가
  final PageController _pageController2 = PageController(); // PageController 추가
  int _currentIndex = 0; // 현재 바텀 네비게이션의 인덱스

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // 로그인 상태 확인
  }

  // 로그인 상태 확인 및 SharedPreferences에서 저장된 정보 불러오기
  Future<void> _checkLoginStatus() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginMethod = prefs.getString('loginMethod');
    String? token = prefs.getString('token');

    if (loginMethod != null && token != null) {
      // 로그인 상태 유효성 확인 (서버 확인 필요시 추가 구현)
      bool isValid = await _validateToken(token, loginMethod);
      setState(() {
        isLoggedIn = isValid;
      });
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  // 서버 또는 Firebase에 토큰 유효성 검사 (여기서는 예시로 true 반환)
  Future<bool> _validateToken(String token, String loginMethod) async {
    // 여기에서 Firebase 또는 서버에 유효성 검사 로직 추가 가능
    return true;
  }

  void _onPageChanged(int index) async {
    if (index == 2 && !await _checkLoginBeforeNavigate()) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0); // 아래에서 위로 올라오게
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      ).then((_) {
        _pageController.jumpToPage(0); // 뒤로가기 시 홈 화면으로 이동
      });
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  // 바텀 네비게이션 클릭 시 호출되는 함수
  Future<void> _onItemTapped(int index) async {
    if (index == 2 && !await _checkLoginBeforeNavigate()) {
      // 로그인되지 않은 경우 LoginScreen으로 Hero 애니메이션과 함께 이동
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0); // 아래에서 위로 올라오게
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
      _pageController.jumpToPage(index); // PageView로 페이지 이동
    }
  }

  Future<bool> _checkLoginBeforeNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginMethod = prefs.getString('loginMethod');
    String? token = prefs.getString('token');
    return (loginMethod != null && token != null);
  }

  // 각 페이지마다 다른 AppBar 설정
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
                  color: Color(0xff1DBE92),
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
          backgroundColor: Colors.white.withOpacity(0.0),
          elevation: 0,
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
      return LoadingScreen(); // 로딩 화면
    } else {
      return Scaffold(
        appBar: _buildAppBar(), // 각 페이지에 맞는 AppBar
        body: PageView(
          controller: _pageController,
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
                    return Container(
                      width: MediaQuery.of(context).size.width * 1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage('assets/title$i.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 10.0),
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
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ),
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
            Container(
              height: 328,
              width: 400,
              child: PageView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage('assets/recom1.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Text(
                            'Mt. Seolark',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
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
                height: 300,
                width: 420,
                child: ListView(
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
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => LoginScreen()),
                    // );
                  },
                  child: SvgPicture.asset(
                    'assets/banners.svg',
                    width: double.infinity,
                    height: 200, // Set an appropriate height
                  ),
                ),
              ],
            ),
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
                children: const [
                  RentalItem(index: '1'),
                  RentalItem(index: '2'),
                  RentalItem(index: '3'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '  Review >',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
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

class PopularCourseItem extends StatelessWidget {
  final int index;

  const PopularCourseItem({required this.index});
  @override
  Widget build(BuildContext context) {
    return Container(
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
