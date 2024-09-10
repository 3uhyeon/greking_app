import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // 섹션별 이미지 및 데이터
  final List<List<Map<String, String>>> productData = [
    [
      {
        'category': 'outer',
        'image': 'assets/outer1.png',
        'image-1': 'assets/outer1-1.png',
        'name': 'OLA HYBRID',
        'price': '1DAY \$3 ',
        'description': 'Training set-up that can be worn up to winter'
      },
      {
        'category': 'outer',
        'image': 'assets/outer2.png',
        'image-1': 'assets/outer2-1.png',
        'name': 'SURROUND jacket',
        'price': '1DAY \$3',
        'description':
            'Applying the exterior of the mechanical stretch with a natural touch'
      },
      {
        'category': 'outer',
        'image': 'assets/outer3.png',
        'image-1': 'assets/outer3-1.png',
        'name': 'ALP Professional Waterproofing',
        'price': '1DAY \$3',
        'description':
            'It is light and fits well when professional hiking by applying C-KNIT BACKER made of Gore 3L material with excellent moisture permeability'
      },
      {
        'category': 'outer',
        'image': 'assets/outer4.png',
        'image-1': 'assets/outer4-1.png',
        'name': 'BLANC 2L jacket',
        'price': '1DAY \$3',
        'description':
            'Applying the exterior of the mechanical stretch with a natural touch'
      },
    ],
    [
      {
        'category': 'shoes',
        'image': 'assets/shoes1.png',
        'image-1': 'assets/shoes1-1.png',
        'name': 'Beige E2',
        'price': '1DAY \$3',
        'description':
            '[X FOAM and X GRIP reduce foot fatigue, provide excellent stability, and GORE-TEX basic tracking with leather sprit overlay]'
      },
      {
        'category': 'shoes',
        'image': 'assets/shoes2.png',
        'image-1': 'assets/shoes2-1.png',
        'name': 'Flyhike Sphere',
        'price': '1DAY \$3',
        'description':
            'Upper injection to control the distortion of the foot is applied to control the foot stably'
      },
      {
        'category': 'shoes',
        'image': 'assets/shoes3.png',
        'image-1': 'assets/shoes3-1.png',
        'name': 'Flyhike Prime',
        'price': '1DAY \$3',
        'description':
            'The upper is applied with air cushion molding that is light and has a good three-dimensional effect'
      },
      {
        'category': 'shoes',
        'image': 'assets/shoes4.png',
        'image-1': 'assets/shoes4-1.png',
        'name': 'Kante',
        'price': '1DAY \$3',
        'description': 'A style dedicated to the Amreung and Riji Mountain'
      },
    ],
    [
      {
        'category': 'stick',
        'image': 'assets/stick1.png',
        'image-1': 'assets/stick1-1.png',
        'name': 'Flash_Premium Carbon',
        'price': '1DAY \$3',
        'description':
            'Excellent lightweight carbon 3-layer stick SET (including case)'
      },
      {
        'category': 'stick',
        'image': 'assets/stick2.png',
        'image-1': 'assets/stick2-1.png',
        'name': 'Carbon three-tiered stick',
        'price': '1DAY \$3',
        'description':
            'Excellent lightweight carbon 3-layer stick SET (including case)'
      },
      {
        'category': 'stick',
        'image': 'assets/stick3.png',
        'image-1': 'assets/stick3-1.png',
        'name': 'T-grip 3-tier stick',
        'price': '1DAY \$3',
        'description':
            'Duralumin T-grip 3-tier stick with double grip for light walking and trekking'
      },
      {
        'category': 'stick',
        'image': 'assets/stick4.png',
        'image-1': 'assets/stick4-1.png',
        'name': 'Carbon stick',
        'price': '1DAY \$3',
        'description':
            'Carbon 4-layer stick set for women with excellent lightweight (including case)'
      },
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    label: 'Hiking shoes',
                    isSelected: selectedIndex == 1,
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  CategoryButton(
                    label: 'Hiking sticks',
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
                '검색결과 (${productData[selectedIndex].length})    ',
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
                itemCount: productData[selectedIndex].length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final product = productData[selectedIndex][index];
                  return ProductItem(
                    index: (index + 1).toString(),
                    name: product['name']!,
                    price: product['price']!,
                    description: product['description']!,
                    imagePath: product['image']!,
                    category: product['category']!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                            index: (index + 1).toString(),
                            name: product['name']!,
                            price: product['price']!,
                            description: product['description']!,
                            imagePath: product['image']!,
                            imageDetailPath: product['image-1']!,
                            category: product['category']!,
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
  final String imagePath;
  final VoidCallback onTap;
  final String category;

  const ProductItem({
    required this.index,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
    required this.onTap,
    required this.category,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Hero(
                    tag: 'product_$index', // 각 상품마다 고유한 태그 설정
                    child: Image.asset(imagePath, fit: BoxFit.fitWidth),
                  ),
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
  final String imagePath;
  final String imageDetailPath;
  final String category;

  const ProductDetailPage({
    required this.index,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
    required this.imageDetailPath,
    required this.category,
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
                  child: Hero(
                    tag: 'product_$index', // 상품 리스트와 같은 tag 사용
                    child: Image.asset(imagePath,
                        fit: BoxFit.cover, width: 300, height: 350),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  Icon(Icons.hiking, color: Color(0XFF868c90), size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Hiking ' + category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0XFF868c90),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF0D615C),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0XFF555A5C),
                ),
              ),
              const SizedBox(height: 32),
              Text('Detail Image',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 10),
              if (category.toLowerCase().contains("stick")) ...[
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(imagePath,
                        fit: BoxFit.cover, width: 300, height: 350),
                  ),
                ),
              ] else ...[
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(imageDetailPath,
                        fit: BoxFit.cover, width: 300, height: 350),
                  ),
                ),
              ],
              if (category.toLowerCase().contains("stick") == false) ...[
                Text(
                  'Size',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (category.toLowerCase().contains("stick") == false) ...[
                  Table(
                    border: TableBorder.all(),
                    children: category.toLowerCase().contains("shoes")
                        ? _buildShoesSizeTable()
                        : _buildOuterSizeTable(),
                  ),
                ],
                const SizedBox(height: 32),
              ],
              Text(
                'Rental Price',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Table(
                border: TableBorder.all(),
                children: _buildRentalPriceTable(),
              ),
              const SizedBox(height: 32),
              Text(
                'Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
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
                          "https://api.mapbox.com/styles/v1/suzzinova/cm0e0akh400xh01ps9yvn19ek/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic3V6emlub3ZhIiwiYSI6ImNtMDFvYW5jZjA0djUycnEzYTQ3ZnYwZ2MifQ._fiK5XHOO8_j1uFBrfK__g",
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Container(),
                  content: Container(
                    width: 500,
                    height: 20,
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
          child: Text('Rent',
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
    );
  }

  // Shoes 사이즈 표
  List<TableRow> _buildShoesSizeTable() {
    return [
      TableRow(children: [
        _buildTableCell('US 8'),
        _buildTableCell('US 8.5'),
        _buildTableCell('US 9'),
        _buildTableCell('US 9.5'),
        _buildTableCell('US 10'),
      ]),
      TableRow(children: [
        _buildTableCell('US 11'),
        _buildTableCell('US 11.5'),
        _buildTableCell('US 12'),
        _buildTableCell('US 12.5'),
        _buildTableCell('US 13'),
      ]),
    ];
  }

  // Outer 사이즈 표
  List<TableRow> _buildOuterSizeTable() {
    return [
      TableRow(children: [
        _buildTableCell('S'),
        _buildTableCell('M'),
        _buildTableCell('L'),
        _buildTableCell('XL'),
        _buildTableCell('XXL'),
      ]),
    ];
  }

  // 렌탈 프라이스 표 (고정된 값으로 설정)
  List<TableRow> _buildRentalPriceTable() {
    return [
      TableRow(children: [
        _buildTableCell('1 day', isHeader: true),
        _buildTableCell('3 days', isHeader: true),
        _buildTableCell('5 days', isHeader: true),
        _buildTableCell('10 days', isHeader: true),
        _buildTableCell('15 days', isHeader: true),
      ]),
      TableRow(children: [
        _buildTableCell('\$3'),
        _buildTableCell('\$5'),
        _buildTableCell('\$8'),
        _buildTableCell('\$15'),
        _buildTableCell('\$22'),
      ]),
    ];
  }

  // 표 셀을 만드는 메서드
  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
