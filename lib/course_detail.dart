import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'review.dart';

class MountainDetailPage extends StatelessWidget {
  final String mountainName;
  final String courseName;
  final String distance;
  final String duration;
  final String difficulty;
  final String altitude;

  MountainDetailPage({
    required this.mountainName,
    required this.courseName,
    required this.distance,
    required this.duration,
    required this.difficulty,
    required this.altitude,
  });

  final LatLng _mapCenter = LatLng(37.5550, 128.2098); // 강원도 중심 좌표

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(' '),
          backgroundColor: Colors.white.withOpacity(0.0), // 투명도 설정된 상단바 배경색
          bottomOpacity: 0.0,
          elevation: 0.0,
          scrolledUnderElevation: 0,
          shape: const Border(
            bottom: BorderSide(
              color: Colors.transparent,
              width: 0.0,
            ),
          ),
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
              height: 224,
              width: 352,
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
                Tab(text: "Hiking Information"),
                Tab(text: "Nearby Restaurants"),
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
            onPressed: () {
              // Booking 버튼 눌렀을 때 동작
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
                  mountainName,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard',
                      color: Color(0xff1dbe92)),
                ),
                SizedBox(width: 8),
                Text(
                  courseName,
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
                _buildInfoChip('Level', difficulty),
                _buildInfoChip('Time', duration),
                _buildInfoChip('Distance', distance),
                _buildInfoChip('Altitude', altitude),
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
                color: Color(0xFFF5F7F8), // 배경색
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
              'Way to Come',
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
                        "https://api.mapbox.com/styles/v1/suzzinova/cm054z5r000i201rbdvg243vw/tiles/256/{z}/{x}/{y}@2x?access_token=sk.eyJ1Ijoic3V6emlub3ZhIiwiYSI6ImNtMDUyOW54bzBiaDkya3NiNGdhbjVqeDgifQ.nvB1cGwKQEgxdlqGWe-hQw",
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
                color: Colors.white, // 배경색
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
                    maxLines: 2, // 2줄만 보여줌
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
                    MaterialPageRoute(
                      builder: (context) => ReviewPage(),
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
}

Widget _buildNearbyRestaurantsTab() {
  // 근처 식당 정보를 여기에 추가합니다.
  return ListView.builder(
    itemCount: 10,
    itemBuilder: (context, index) {
      return Card(
        color: Colors.transparent, // Set the background color to transparent
        elevation: 0, // No shadow

        child: ListTile(
          leading: Container(
            width: 60,
            height: 150, // 원하는 높이로 설정

            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // 이미지의 모서리를 둥글게 만듦
              child: Image.asset(
                'assets/mo.png',
                fit: BoxFit.cover, // 이미지를 컨테이너 크기에 맞게 조정
              ),
            ),
          ),
          minTileHeight: 68,
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
