import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'map.dart';
import 'main.dart';
import 'mypage.dart';
import 'mycourse.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  // 네비게이션 클릭 전에 로그인 상태 확인 함수
  Future<bool> _checkLoginBeforeNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginMethod = prefs.getString('loginMethod');
    String? token = prefs.getString('token');

    return (loginMethod != null && token != null);
  }

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

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'search',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CategoryButton(
                    label: 'Hiking Outers',
                    isSelected: selectedIndex == 0,
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  CategoryButton(
                    label: 'Hiking boots',
                    isSelected: selectedIndex == 1,
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  CategoryButton(
                    label: 'Hiking gear',
                    isSelected: selectedIndex == 2,
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '검색결과 (?)    ',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ProductItem(
                    index: (index + 1).toString(),
                    name: 'Product Name',
                    price: '\$1000',
                    description:
                        'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                            index: (index + 1).toString(),
                            name: 'Product Name',
                            price: '\$1000',
                            description:
                                'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        onTap: (index) async {
          if ((index == 2) && !await _checkLoginBeforeNavigate()) {
            // 로그인되지 않은 경우 로그인 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          } else {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Treking()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyCourse()),
                );
                break;
              case 3:
                break;
              case 4:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => My()),
                );
                break;
            }
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/navi_home_off.svg'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/navi_second_off.svg'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/navi_third_off.svg'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/navi_four_on.svg'),
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

class CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
        decoration: BoxDecoration(
          color: isSelected ? Color(0XFF1DBE92) : Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String index;
  final String name;
  final String price;
  final String description;
  final VoidCallback onTap;

  const ProductItem({
    required this.index,
    required this.name,
    required this.price,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 168,
        height: 220,
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset('assets/outer$index.png'),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '  $name',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF0D615C),
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                '  $price',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0XFF868C90),
                  fontFamily: 'Pretendard',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final String index;
  final String name;
  final String price;
  final String description;

  const ProductDetailPage({
    required this.index,
    required this.name,
    required this.price,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset('assets/outer$index.png'),
                ),
              ),
              const SizedBox(height: 100),
              Text(
                'Product Detail',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Color(0XFF868c90),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF0D615C),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0XFF868C90),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0XFF555A5C),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 143,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: FlutterMap(
                  options: MapOptions(
                    initialZoom: 10,
                    minZoom: 10,
                    maxZoom: 12,
                    initialCenter: LatLng(37.4602, 126.4407),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://api.mapbox.com/styles/v1/suzzinova/cm054z5r000i201rbdvg243vw/tiles/256/{z}/{x}/{y}@2x?access_token=sk.eyJ1Ijoic3V6emlub3ZhIiwiYSI6ImNtMDUyOW54bzBiaDkya3NiNGdhbjVqeDgifQ.nvB1cGwKQEgxdlqGWe-hQw",
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(37.4602, 126.4407),
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
              const SizedBox(height: 32),
              Text('Caution',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard')),
              SizedBox(height: 14),
              Text(
                '# Please return the product by 6:00 PM on the day of rental. \n# If you do not return the product by the due date, you will be charged a late fee.\n# If the product is damaged, you will be charged a repair fee.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF555A5C),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // "Currently out of stock" 알림 메시지 출력
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Container(),
                          content: Container(
                            width: 500,
                            height: 30,
                            child: Center(
                              child: Text('Currently out of stock',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          actions: [
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFF1DBE92),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Rent',
                    style: TextStyle(
                      fontSize: 18,
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
}
