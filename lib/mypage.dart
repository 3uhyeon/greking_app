import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/privacy.dart';
import 'package:my_app/terms.dart';
import 'map.dart';
import 'main.dart';
import 'shop.dart';
import 'mycourse.dart';
import 'privacy.dart';
import 'terms.dart';

class My extends StatefulWidget {
  const My({super.key});
  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<My> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        leadingWidth: 200,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0XFF1DBE92),
                  child: Text(
                    'MJ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kim MinJune',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '1234545@example.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Level 1',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF0D615C),
                      ),
                    ),
                    Text(
                      '  1000/6000',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                SvgPicture.asset(
                  'assets/level_icon.svg',
                  width: 100,
                  height: 100,
                ),
                SizedBox(width: 10),
              ],
            ),
            LinearProgressIndicator(
              value: 5000 / 6000,
              backgroundColor: Colors.grey[300],
              color: Color(0XFF1DBE92),
              minHeight: 16,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                buildMenuItem(
                  text: 'Rent reservation',
                  onTap: () {},
                ),
                buildMenuItem(
                  text: 'App version',
                  onTap: () {},
                ),
                buildMenuItem(
                  text: 'Notification',
                  onTap: () {},
                ),
                SizedBox(height: 20),
                buildMenuItem(
                  text: 'Terms of Use',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TermsOfUse()),
                    );
                  },
                ),
                buildMenuItem(
                  text: 'Location Information',
                  onTap: () {},
                ),
                buildMenuItem(
                  text: 'Privacy policy',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Privacy()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 4,
        onTap: (index) {
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Shop()),
              );
              break;
            case 4:
              // Current page
              break;
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
            icon: SvgPicture.asset('assets/navi_four_off.svg'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/navi_five_on.svg'),
            label: '',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget buildMenuItem({required String text, required VoidCallback onTap}) {
    onTap:
    () {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Map()),
      // );
    };
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: Color(0xFFECF0F2),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: Color(0xFF1D2228),
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF1D2228),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
