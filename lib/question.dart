import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/main.dart';
import 'package:lottie/lottie.dart';

class QuestionScreen extends StatefulWidget {
  final String uid;

  QuestionScreen({required this.uid});
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _currentQuestionIndex = 0;
  int _selectedAnswerIndex = -1; // -1 means no selection
  double _progressValue = 0.0; // 초기 진행률 (0%)
  List<int> _answersSelected = [-1, -1, -1, -1]; // 각 질문에 대한 선택 저장

  List<String> _questions = [
    "How often\nhave you been hiking? (1/4)",
    "Do you enjoy\n reqular exercise? (2/4)",
    "How fast can you run \n100 meters? (3/4)",
    "What was the last\nmountain's elevation? (4/4)",
  ];

  // 질문마다 다른 답변
  List<List<String>> _answers = [
    ["0 years", "1-3 years", "3-5 years", "5-7 years", "7+ years"],
    ["Yes, very much", "Yes, somewhat", "Neutral", "Not really", "Not at all"],
    [
      "Under 12 seconds",
      "12-15 seconds",
      "15-18 seconds",
      "18-22 seconds",
      "22+ seconds"
    ],
    [
      "Under 500 meters (Not yet)",
      "500-1000 meters",
      "1000-1500 meters",
      "Over 2000 meters"
    ],
  ];

  // 서버로 결과 전송
  Future<void> _sendSurveyResults() async {
    print(widget.uid); // 전달받은 UID 출력
    // 유저 아이디와 선택한 답변들을 전송하는 데이터
    var data = {
      "userId": widget.uid, // 이 부분은 실제 사용자 ID로 대체되어야 합니다.
      "surveyResult": {
        "questionAnswer1": _answersSelected[0] + 2,
        "questionAnswer2": _answersSelected[1] + 2,
        "questionAnswer3": _answersSelected[2] + 2,
        "questionAnswer4": _answersSelected[3] + 2,
      }
    };

    // HTTP POST 요청을 통해 서버로 데이터 전송
    try {
      final response = await http.post(
        Uri.parse('http://43.203.197.86:8080/api/survey/submit'), // 서버 URL 확인
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data), // 데이터 인코딩
      );

      if (response.statusCode == 200) {
        print("Survey results sent successfully!");
      } else {
        print("Failed to send survey results: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error occurred while sending survey results: $e");
    }
  }

  void _nextQuestion() {
    if (_selectedAnswerIndex != -1) {
      setState(() {
        // 선택한 답변 저장
        _answersSelected[_currentQuestionIndex] = _selectedAnswerIndex;
        print(
            "Question $_currentQuestionIndex answer selected: $_selectedAnswerIndex");
        debugPrint(_selectedAnswerIndex.toString());
        if (_currentQuestionIndex < _questions.length - 1) {
          // 진행률 업데이트
          _progressValue = (_currentQuestionIndex + 1) / _questions.length;
          // 다음 질문으로 이동
          _currentQuestionIndex++;
          print("Moving to question $_currentQuestionIndex");
          _selectedAnswerIndex = -1; // Reset selection for the new question
        } else {
          // 마지막 질문일 경우
          print("All questions answered: $_answersSelected");
          _sendSurveyResults(); // 마지막 질문에 대한 답변을 서버로 전송
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CompletionScreen()),
          );
        }
      });
    } else {
      print("No answer selected for question $_currentQuestionIndex");
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false, // 뒤로 가기 비활성화
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F7),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                _questions[_currentQuestionIndex],
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.0),
              for (int i = 0; i < _answers[_currentQuestionIndex].length; i++)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAnswerIndex = i;
                      print("Answer $i selected");
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: _selectedAnswerIndex == i
                          ? Colors.white
                          : Color(0xffecf0f2),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: _selectedAnswerIndex == i
                            ? Colors.green
                            : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    child: Text(
                      _answers[_currentQuestionIndex][i],
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.normal,
                        color: _selectedAnswerIndex == i
                            ? Colors.green
                            : Color(0xff868c90),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              SizedBox(height: 50.0),
              LinearProgressIndicator(
                value: _progressValue,
                backgroundColor: Colors.grey[300],
                minHeight: 8.0,
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.green,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _selectedAnswerIndex == -1 ? null : _nextQuestion,
                child: Text("Next", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 70),
                  backgroundColor: Color(0xff1dbe92),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompletionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // 뒤로 가기 비활성화
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F7),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Congratulations!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'You have completed the survey.',
                style: TextStyle(fontSize: 18.0, color: Colors.grey[600]),
              ),
              Lottie.asset('assets/cong.json'),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                },
                child: Text("Go to Greking",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 70),
                  backgroundColor: Color(0xff1dbe92),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
