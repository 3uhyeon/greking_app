import 'dart:convert'; // JSON 인코딩을 위해 필요
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // HTTP 요청을 위해 추가
import 'package:my_app/loading.dart';
import 'package:my_app/terms.dart';
import 'privacy.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      home: Signup(),
    );
  }
}

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String _errorText = ""; // 오류 메시지를 저장할 변수
  bool isLoading = false; // 로딩 상태를 저장할 변수
  final _formKey = GlobalKey<FormState>(); // 폼 키
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  bool _obscureText = true; // 비밀번호 숨김 여부
  bool _isCheckingNickname = false; // 닉네임 중복 확인 상태
  bool _isNicknameValid = false; // 닉네임 유효성 여부
  bool _isFormValid = false; // 폼의 유효성 상태
  bool _isAgreed = false; // 약관 동의 여부
  bool _isPrivacyAgreed = false; // 개인정보 처리방침 동의 여부
  final String _emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'; // 이메일 정규식

  // 폼의 모든 필드가 유효한지 확인하는 함수
  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState!.validate() && _isNicknameValid;
    });
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

        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFF4F6F7), // 배경색 설정
        body: SingleChildScrollView(
          // SingleChildScrollView로 전체를 감쌈
          padding: const EdgeInsets.all(16.0), // 여백 설정
          child: Form(
            key: _formKey, // 폼 키 지정
            onChanged: _validateForm, // 폼의 상태가 변경될 때마다 유효성 검사
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 세로 방향으로 가운데 정렬
              crossAxisAlignment: CrossAxisAlignment.stretch, // 가로 방향으로 꽉 채움
              children: <Widget>[
                SizedBox(height: 40.0), // 공간 추가
                Text(
                  'Please create\nyour account', // 제목 텍스트
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
                    hintText: '',
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
                      return 'Please check your email format';
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
                        color: Colors.grey,
                      ),
                      hintText: '',
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
                      return 'Password must be 8-16 characters';
                    }
                    if (!RegExp(r'^(?=.*?[0-9])(?=.*?[!@#$%^&*()_\-+=]).*$')
                        .hasMatch(value)) {
                      return 'Password must contain a number and a special character';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.0),
                Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard',
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _passwordConfirmController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Please confirm your password',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    hintText: '',
                    filled: true,
                    fillColor: const Color(0xFFECF0F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.0),
                Text(
                  'Nickname',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard',
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _nicknameController,
                  decoration: InputDecoration(
                    labelText: 'Please create your nickname',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    hintText: '',
                    filled: true,
                    fillColor: const Color(0xFFECF0F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: _isCheckingNickname
                        ? LoadingScreen() // 중복 확인 중 로딩 아이콘
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff1dbe92),
                            ),
                            onPressed: _checkNickname, // 닉네임 중복 확인 함수 호출
                            child: Text('Check ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10)),
                          ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please create your nickname';
                    }
                    if (!_isNicknameValid) {
                      return 'This nickname is already taken';
                    } else {
                      return 'This nickname is available';
                    }
                  },
                ),
                SizedBox(height: 10.0),
                if (_errorText.isNotEmpty)
                  Text(
                    _errorText,
                    style: TextStyle(color: const Color(0xFFFF74440)),
                  ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _isAgreed,
                      onChanged: (value) {
                        setState(() {
                          _isAgreed = value!;
                        });
                      },
                      activeColor: Color(
                          0xff1dbe92), // Set the background color of the checkbox when checked
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Privacy();
                        }));
                      },
                      child: Text(
                        'Agree to Privacy Policy',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Checkbox(
                      value: _isPrivacyAgreed,
                      onChanged: (value) {
                        setState(() {
                          _isPrivacyAgreed = value!;
                        });
                      },
                      activeColor: Color(
                          0xff1dbe92), // Set the background color of the checkbox when checked
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TermsOfUse();
                        }));
                      },
                      child: Text(
                        'Agree to Terms of Use',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100.0),
                ElevatedButton(
                  onPressed: _isFormValid ? _signUp : null, // 유효할 때만 버튼 활성화
                  child: Text('Sign up',
                      style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(352, 70),
                    backgroundColor: _isFormValid
                        ? const Color(0xFF1dbe92)
                        : Colors.grey, // 유효하지 않으면 회색
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    textStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard',
                      color: Colors.white,
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

  // 닉네임 중복 확인 함수 (API 연동 필요)
  Future<void> _checkNickname() async {
    setState(() {
      _isCheckingNickname = true;
    });

    // Call the API to validate the nickname
    var response = await http.get(
      Uri.parse('http://localhost:8080/api/users/validate/UserNickname2'),
    );

    if (response.statusCode == 200) {
      // Nickname is valid (not duplicate)
      setState(() {
        _isCheckingNickname = false;
        _isNicknameValid = true;
        _validateForm();
      });
    } else {
      // Nickname is invalid (duplicate)
      setState(() {
        _isCheckingNickname = false;
        _isNicknameValid = false;
        _validateForm();
      });
    }
  }

  // 회원가입 함수 (Spring Boot 서버 API 연동)
  Future<void> _signUp() async {
    if (_formKey.currentState!.validate() && _isAgreed && _isPrivacyAgreed) {
      try {
        isLoading = true; // 로딩 상태로 변경
        var response = await http.post(
          Uri.parse('http://localhost:8080/api/users/register'), // API URL
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "email": _emailController.text,
            "password": _passwordController.text,
            "nickname": _nicknameController.text,
            "termsOfServiceAccepted": _isAgreed,
            "privacyPolicyAccepted": _isPrivacyAgreed,
            "grade": {
              "level": 1,
              "experience": 0,
            }
          }),
        );

        if (response.statusCode == 200) {
          isLoading = false; // 로딩 상태 해제
          // 회원가입 성공 처리 (예: 메인 페이지로 이동)
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyApp()));
        } else {
          setState(() {
            isLoading = false; // 로딩 상태 해제
            _errorText = "Failed to Sign up. Please try again.";
          });
        }
      } catch (e) {
        setState(() {
          isLoading = false; // 로딩 상태 해제
          _errorText = "Error occurred. Please try again.";
        });
      }
    } else {
      setState(() {
        _isAgreed = false;
        _errorText = "Please agree to the terms and privacy policy.";
      });
    }
  }
}
