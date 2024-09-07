import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase 초기화를 위해 추가
import 'package:flutter_signin_button/flutter_signin_button.dart'; // SignInButton 패키지 추가
import 'signup.dart';
import 'question.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String _errorText = ""; // 오류 메시지를 저장할 변수
  final _formKey = GlobalKey<FormState>(); // 폼 키
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true; // 비밀번호 숨김 여부

  final String _emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'; // 이메일 정규식

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
        _errorText = "Google 로그인에 실패했습니다.";
      });
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(),
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
                  'Welcome Please\nSign in', // 제목 텍스트
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
                      color: Colors.grey, // Set the text color to blue
                    ),
                    hintText: ' ',
                    filled: true,
                    fillColor: const Color(0xFFECF0F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    final regex = RegExp(_emailPattern);
                    if (!regex.hasMatch(value)) {
                      return 'Please check your ID or Password';
                    }
                    return null;
                  },
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
                        color: Colors.grey, // Set the text color to blue
                      ),
                      hintText: ' ',
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 8 || value.length > 16) {
                      return 'Please check your ID or Password';
                    }
                    if (!RegExp(r'^(?=.*?[0-9])(?=.*?[!@#$%^&*()_\-+=]).*$')
                        .hasMatch(value)) {
                      return 'Please check your ID or Password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                if (_errorText.isNotEmpty)
                  Text(
                    _errorText,
                    style: TextStyle(color: const Color(0xFFFF74440)),
                  ),
                SizedBox(height: 100.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Signup()),
                        );
                      },
                      child: Text('Sign up',
                          style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuestionScreen()),
                        );
                      },
                      child: Text('Find password',
                          style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),

                ElevatedButton(
                  onPressed: () => _signInWithGoogle(), // 구글 로그인 버튼 클릭 시 실행할 함수
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
                  onPressed: _login,
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

  void _login() {
    setState(() {
      _errorText = "Please check your ID or Password";
    });
  }

  void _forgotPassword() {
    // 비밀번호 찾기 버튼 클릭 시 실행할 코드 작성
  }
}
