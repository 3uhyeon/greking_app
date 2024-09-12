import 'package:flutter/material.dart';
import 'package:my_app/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'loading.dart';
import 'mycourse.dart';
import 'login.dart';

class ReviewWritingPage extends StatefulWidget {
  const ReviewWritingPage({Key? key}) : super(key: key);
  @override
  _ReviewWritingPageState createState() => _ReviewWritingPageState();
}

class _ReviewWritingPageState extends State<ReviewWritingPage> {
  int _selectedStar = 0;
  int _selectedDifficulty = -1;
  bool isLoading = false;
  final TextEditingController _reviewController = TextEditingController();
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
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
    if (!isLoggedIn) {
      _navigateToLogin();
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Construct the review body
    final body = {
      "review_score": _selectedStar.toString(),
      "review_difficulty": _getDifficultyText(),
      "review_text": _reviewController.text
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/review/userid/userCouserId'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        // If the server returns an OK response, navigate to the MyCourse page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyCourse()),
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

  void _navigateToLogin() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0); // Slide from bottom to top
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
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
                      Text('Nickname',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('Mt.Seolak',
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
                    onPressed: _reviewRegister,
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
