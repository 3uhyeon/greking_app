import 'dart:convert'; // JSON 인코딩을 위해 필요
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/loading.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences 추가
import 'package:http/http.dart' as http; // HTTP 요청을 위해 추가
import 'signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main.dart'; // 로그인 성공 후 메인 화면으로 이동하기 위해 추가

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false; // 로딩 상태를 저장할 변수
  String _errorText = ""; // 전체 오류 메시지를 저장할 변수
  String _emailErrorMessage = ""; // 이메일 오류 메시지
  String _passwordErrorMessage = ""; // 비밀번호 오류 메시지
  Color _emailMessageColor = Colors.red; // 이메일 메시지 색상
  Color _passwordMessageColor = Colors.red; // 비밀번호 메시지 색상

  final _formKey = GlobalKey<FormState>(); // 폼 키
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true; // 비밀번호 숨김 여부

  final String _emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'; // 이메일 정규식

  // 이메일/비밀번호 로그인 (Spring Boot API)
  Future<void> _signInWithEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        String email = _emailController.text;
        String password = _passwordController.text;
        setState(() {
          isLoading = true; // 로딩 상태 변경
        });
        // API 요청 보내기
        var response = await http.post(
          Uri.parse('http://localhost:8080/api/users/login'), // 서버 URL
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': email,
            'password': password,
            'uid': 'some-unique-id', // Firebase UID가 없을 경우 고유 식별자 생성 필요
          }),
        );

        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          setState(() {
            isLoading = false; // 로딩 상태 변경
          });
          // 로그인 성공 시 로그인 상태 저장
          await _saveLoginState('email', responseData['uid'], email, '');

          // 메인 페이지로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ),
          );
        } else {
          setState(() {
            isLoading = false; // 로딩 상태 변경
            _errorText = "Failed to Sign in. Please check your ID or Password.";
          });
        }
      } catch (e) {
        setState(() {
          isLoading = false; // 로딩 상태 변경
          _errorText = "Error occurred. Please try again.";
        });
      }
    }
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      setState(() {
        _errorText = "Failed to Google Sign in.";
      });
      return null;
    }
  }

  // 로그인 상태를 SharedPreferences에 저장
  Future<void> _saveLoginState(
      String method, String uid, String email, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('loginMethod', method);
    await prefs.setString('token', uid);
    await prefs.setString('email', email);
    if (name.isNotEmpty) {
      await prefs.setString('name', name);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingScreen();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Container(),
          backgroundColor: Colors.white.withOpacity(0.0), // 투명도 설정된 상단바 배경색
          bottomOpacity: 0.0,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: const Color(0xFFF4F6F7), // 배경색 설정
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // 여백 설정
            child: Form(
              key: _formKey, // 폼 키 지정
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // 세로 방향으로 가운데 정렬
                crossAxisAlignment: CrossAxisAlignment.stretch, // 가로 방향으로 꽉 채움
                children: <Widget>[
                  SizedBox(height: 30.0), // 공간 추가
                  Text(
                    'Welcome Please\nSign In', // 제목 텍스트
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  SizedBox(height: 40.0), // 공간 추가
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Please enter your email',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFECF0F2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      final regex = RegExp(_emailPattern);
                      setState(() {
                        if (value.isEmpty || !regex.hasMatch(value)) {
                          _emailErrorMessage = '    Please check your email';
                          _emailMessageColor = Color(0xfff74440);
                        } else {
                          _emailErrorMessage = '    This email is correct form';
                          _emailMessageColor = Colors.green;
                        }
                      });
                    },
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      SizedBox(width: 8.0),
                      if (_emailMessageColor == Colors.green)
                        SvgPicture.asset('assets/check_circle.svg',
                            width: 16, height: 16),
                      if (_emailMessageColor == Color(0xfff74440))
                        SvgPicture.asset('assets/check_circle2.svg',
                            width: 16, height: 16),
                      Text(
                        _emailErrorMessage,
                        style:
                            TextStyle(color: _emailMessageColor, fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                        labelText: 'Please enter your password',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFECF0F2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )),
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          _passwordErrorMessage =
                              '    Please check your password';
                          _passwordMessageColor = Color(0xfff74440);
                        } else if (value.length < 8 || value.length > 16) {
                          _passwordErrorMessage =
                              '    Password must be 8-16 characters';
                          _passwordMessageColor = Color(0xfff74440);
                        } else if (!RegExp(
                                r'^(?=.*?[0-9])(?=.*?[!@#$%^&*()_\-+=]).*$')
                            .hasMatch(value)) {
                          _passwordErrorMessage =
                              '    Password must contain a number and special character';
                          _passwordMessageColor = Color(0xfff74440);
                        } else {
                          _passwordErrorMessage =
                              '    This Password is correct form';
                          _passwordMessageColor = Colors.green;
                        }
                      });
                    },
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      if (_passwordMessageColor == Colors.green)
                        SvgPicture.asset('assets/check_circle.svg',
                            width: 16, height: 16),
                      if (_passwordMessageColor == Color(0xfff74440))
                        SvgPicture.asset('assets/check_circle2.svg',
                            width: 16, height: 16),
                      Text(
                        _passwordErrorMessage,
                        style: TextStyle(
                            color: _passwordMessageColor, fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  if (_errorText.isNotEmpty)
                    Text(
                      _errorText,
                      style: TextStyle(color: const Color(0xFFFF74440)),
                    ),
                  SizedBox(height: 70.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      Signup(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0); // 오른쪽에서 왼쪽으로
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
                        child: Text('Sign up',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0)),
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Container(),
                                content: Container(
                                  color: Colors.white.withOpacity(0.0),
                                  width: 500,
                                  height: 30,
                                  child: Center(
                                    child: Text('Please Contact the Admin',
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
                        child: Text('Find password',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () =>
                        _signInWithGoogle(), // 구글 로그인 버튼 클릭 시 실행할 함수
                    child: Row(
                      children: [
                        SizedBox(width: 20.0),
                        SvgPicture.asset('assets/google.svg'),
                        Text('            Sign In with Google',
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0)),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      textStyle: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pretendard',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: _signInWithEmail, // 이메일/비밀번호 로그인 버튼
                    child: Text('Sign In',
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 70),
                      backgroundColor: const Color(0xFF1dbe92),
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      textStyle: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pretendard',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
