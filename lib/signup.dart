import 'package:flutter/material.dart';
import 'package:my_app/terms.dart';
import 'privacy.dart';
import 'terms.dart';

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
      resizeToAvoidBottomInset: false,
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
                        _obscureText ? Icons.visibility_off : Icons.visibility,
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
                      ? CircularProgressIndicator() // 중복 확인 중 로딩 아이콘
                      : IconButton(
                          icon: Icon(
                            Icons.check,
                            color:
                                _isNicknameValid ? Colors.green : Colors.grey,
                          ),
                          onPressed: _checkNickname, // 닉네임 중복 확인 함수 호출
                        ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please create your nickname';
                  }
                  if (!_isNicknameValid) {
                    return 'This nickname is already taken';
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

  // 닉네임 중복 확인 함수 (API 연동 필요)
  Future<void> _checkNickname() async {
    setState(() {
      _isCheckingNickname = true;
    });

    // 가정된 중복 확인 로직 (2초 대기 후 중복 아님 처리)
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isCheckingNickname = false;
      _isNicknameValid = true; // 중복되지 않음 (테스트용)
      _validateForm(); // 닉네임 확인 후 폼 다시 확인
    });
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _errorText = "";
      });
      // 회원가입 로직 처리
    } else {
      setState(() {
        _errorText = "Please check your inputs.";
      });
    }
  }
}
