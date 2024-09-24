import 'package:flutter/material.dart';
import 'package:my_app/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'loading.dart';
import 'mycourse.dart';
import 'login.dart';
import 'write_done.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReviewWritingPage extends StatefulWidget {
  final int userCourseId;
  final String courseName;

  ReviewWritingPage({required this.userCourseId, required this.courseName});
  @override
  _ReviewWritingPageState createState() => _ReviewWritingPageState();
}

class _ReviewWritingPageState extends State<ReviewWritingPage> {
  int _selectedStar = 0;
  int _selectedDifficulty = -1;
  bool isLoading = false;
  final String _url = 'http://43.203.197.86:8080';
  final TextEditingController _reviewController = TextEditingController();
  bool isLoggedIn = false;
  String name = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    getUserInfo();
  }

  // 이메일, 닉네임, 레벨, 숙련도 가져오는 API 생성
  Future<void> getUserInfo() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('uid'); // 다시 한번 null 체크
      if (userId == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      var response = await http.get(
        Uri.parse('$_url/api/users/$userId'), // 서버 주소와 userId를 동적으로 할당
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);

        setState(() {
          name = data['nickname'];

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginMethod = prefs.getString('loginMethod');
    String? token = prefs.getString('token');

    if (loginMethod != null && token != null) {
      setState(() {
        isLoggedIn = true;
      });
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  void _selectStar(int star) {
    setState(() {
      _selectedStar = star;
    });
  }

  void _selectDifficulty(int difficulty) {
    setState(() {
      _selectedDifficulty = difficulty;
    });
  }

  Future<void> _reviewRegister() async {
    setState(() {
      isLoading = true;
    });

    // Construct the review body
    final body = {
      "review_score": _selectedStar.toString(),
      "review_difficulty": _getDifficultyText(),
      "review_text": _reviewController.text
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('uid');

    try {
      final response = await http.post(
        Uri.parse(
            'http://43.203.197.86:8080/api/review/${userId}/${widget.userCourseId}'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WritingDoneScreen()),
        );
      } else {
        throw Exception('Failed to submit review');
      }
    } catch (e) {
      print('Error submitting review: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getDifficultyText() {
    switch (_selectedDifficulty) {
      case 0:
        return 'difficult';
      case 1:
        return 'manageable';
      case 2:
        return 'easy';
      default:
        return 'unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingScreen();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(''),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(widget.courseName.replaceAll('_', ' '),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.0),
                Text('   Rating',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pretendard')),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        Icons.star,
                        size: 50.0,
                        color: index < _selectedStar
                            ? Color(0XFF1DBE92)
                            : Colors.grey[300],
                      ),
                      onPressed: () => _selectStar(index + 1),
                    );
                  }),
                ),
                SizedBox(height: 32.0),
                Text('   Level',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pretendard')),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDifficultyButton(
                        0, 'Difficult', Icons.sentiment_very_dissatisfied),
                    _buildDifficultyButton(
                        1, 'Manageable', Icons.sentiment_neutral),
                    _buildDifficultyButton(
                        2, 'Easy', Icons.sentiment_very_satisfied),
                  ],
                ),
                SizedBox(height: 32.0),
                Text('  Write a Review',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pretendard')),
                SizedBox(height: 12.0),
                TextField(
                  controller: _reviewController,
                  maxLines: 4,
                  maxLength: 200,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0XFFEBEFF2),
                    hintText: 'Write your review here in 200 characters',
                    hintStyle: TextStyle(color: Color(0xFFA9B0B5)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Container(
                              width: 500,
                              height: 120,
                              child: Center(
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/alert_check.svg',
                                      width: 70,
                                      height: 70,
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Are you sure to submit?',
                                      style: TextStyle(
                                        color: Color(0xff555a5c),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
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
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 16),
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
                                        'Sure',
                                        style: TextStyle(
                                            color: Color(0xff1dbe9c),
                                            fontSize: 16),
                                      ),
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        await _reviewRegister();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(350, 45),
                      backgroundColor: Color(0XFF1DBE92),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 17),
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

  Widget _buildDifficultyButton(int index, String label, IconData icon) {
    return GestureDetector(
      onTap: () => _selectDifficulty(index),
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: _selectedDifficulty == index
              ? Color(0XFF1DBE92)
              : Color(0XFFEBEFF2),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 80,
              color: _selectedDifficulty == index
                  ? Colors.white
                  : Colors.grey[600],
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: _selectedDifficulty == index
                    ? Colors.white
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
