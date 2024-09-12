import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/location_info.dart';
import 'package:my_app/privacy.dart';
import 'package:my_app/terms.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class My extends StatefulWidget {
  const My({super.key});
  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<My> {
  bool isLoggedIn = false;
  String? email;
  String? name;
  bool _isChecked = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;
  String _errorText = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // 로그인 상태 확인
  }

  // 로그인 상태 확인 및 SharedPreferences에서 저장된 정보 불러오기
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginMethod = prefs.getString('loginMethod');
    String? token = prefs.getString('token');
    String? savedEmail = prefs.getString('email'); // 저장된 이메일
    String? savedName = prefs.getString('name'); // 저장된 사용자 이름

    if (loginMethod != null && token != null) {
      setState(() {
        isLoggedIn = true;
        email = savedEmail ?? '1234545@example.com'; // 이메일이 없으면 기본값
        name = savedName ?? 'Kim MinJune'; // 이름이 없으면 기본값
      });
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  // 이메일/비밀번호 회원 탈퇴
  Future<void> _deleteAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    String? token = prefs.getString('token');

    if (uid == null || token == null) {
      setState(() {
        _errorText = "User not logged in.";
      });
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      var response = await http.delete(
        Uri.parse('http://10.223.121.249:8080/api/users/$uid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // 인증 토큰
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });

        await prefs.clear(); // SharedPreferences 데이터 제거
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
          _errorText = "Failed to delete account.";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        _errorText = "Error occurred. Please try again.";
      });
    }
  }

  // Google 계정 삭제
  Future<void> _deleteGoogleAccount() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        setState(() {
          isLoading = true;
        });

        await user.delete(); // Firebase에서 계정 삭제

        setState(() {
          isLoading = false;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear(); // SharedPreferences 데이터 제거

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } else {
        setState(() {
          _errorText = "No user found.";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        _errorText = "Failed to delete Google account.";
      });
    }
  }

  // 로그아웃 함수
  Future<void> _signOut() async {
    try {
      // 구글 로그인 로그아웃 처리
      if (_googleSignIn.currentUser != null) {
        await _googleSignIn.signOut();
      }

      // Firebase 로그아웃 처리
      await _auth.signOut();

      // SharedPreferences에서 로그인 정보 삭제
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 로그인 화면으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } catch (e) {
      setState(() {
        _errorText = "Failed to sign out. Please try again.";
      });
    }
  }

  // 회원탈퇴 다이얼로그
  Future<void> _showDeleteAccountDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 500,
            height: 30,
            child: Center(
              child: Text('Are you sure to delete account? ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal)),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(width: 50),
                Container(
                  child: TextButton(
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? loginMethod = prefs.getString('loginMethod');

                      if (loginMethod == 'email') {
                        await _deleteAccount(); // 이메일 로그인 사용자의 회원 탈퇴
                      } else if (loginMethod == 'google') {
                        await _deleteGoogleAccount(); // Google 로그인 사용자의 회원 탈퇴
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // 회원탈퇴 다이얼로그
  Future<void> _showSignoutAccountDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 500,
            height: 30,
            child: Center(
              child: Text('Are you sure to Sign out ? ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal)),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(width: 50),
                Container(
                  child: TextButton(
                    child: Text(
                      'Sign out',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await _signOut(); // 로그아웃
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/mypicture.svg', width: 52, height: 52),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isLoggedIn
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name ?? 'Kim MinJune',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                email ?? '1234545@example.com',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '  Need to Sign In',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0d615c),
                                ),
                              ),
                              SizedBox(width: 50),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          LoginScreen(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(0.0, 1.0);
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOut;
                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        var offsetAnimation =
                                            animation.drive(tween);

                                        return SlideTransition(
                                            position: offsetAnimation,
                                            child: child);
                                      },
                                    ),
                                  );
                                },
                                child: Text('Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    )),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1DBE92),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
                Spacer(),
              ],
            ),
            const SizedBox(height: 24),
            // 로그인 상태일 때만 레벨과 진행 상태 표시
            if (isLoggedIn)
              Row(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Level 1',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF0D615C),
                        ),
                      ),
                      Text(
                        '  1000/6000',
                        style: TextStyle(
                          fontSize: 16,
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
            if (isLoggedIn)
              LinearProgressIndicator(
                value: 1000 / 6000,
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
                SizedBox(height: 2),
                buildMenuItem(
                  text: 'App version',
                  onTap: () {},
                ),
                SizedBox(height: 2),
                buildNoticeItem(
                  text: 'Notification',
                  onTap: () {},
                ),
                SizedBox(height: 20),
                buildMenuItem(
                  text: 'Terms of Use',
                  onTap: () {},
                ),
                SizedBox(height: 2),
                buildMenuItem(
                  text: 'Location Information',
                  onTap: () {},
                ),
                SizedBox(height: 2),
                buildMenuItem(
                  text: 'Privacy policy',
                  onTap: () {},
                ),
                SizedBox(height: 70),
                TextButton(
                  onPressed: () {
                    _showSignoutAccountDialog(); // 로그아웃 확인 다이얼로그 표시
                  },
                  child: Text('Sign out',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      )),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(350, 45),
                    backgroundColor: Color(0xFFECF0F2),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    _showDeleteAccountDialog(); // 탈퇴 확인 다이얼로그 표시
                  },
                  child: Text('Delete account',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      )),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(350, 45),
                    backgroundColor: Color(0xFFECF0F2),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({required String text, required VoidCallback onTap}) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: Color(0xFFECF0F2),
        borderRadius: BorderRadius.circular(10),
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

  Widget buildNoticeItem({required String text, required VoidCallback onTap}) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: Color(0xFFECF0F2),
        borderRadius: BorderRadius.circular(10),
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
            Switch(
              value: _isChecked,
              activeColor: Color(0xff1dbe92),
              activeTrackColor: Color(0xff0d615c).withOpacity(1),
              inactiveTrackColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _isChecked = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
