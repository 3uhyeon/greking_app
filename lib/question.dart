import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _currentQuestionIndex = 0;
  int _selectedAnswerIndex = -1; // -1 means no selection
  double _progressValue = 0.0; // 초기 진행률 (0%)

  List<String> _questions = [
    "How often\nhave you been hiking? (1/4)",
    "Do you enjoy\n reqular exercise? (2/4)",
    "How fast can you run \n100 meters? (3/4)",
    "What was the last\nmountain's elevation? (4/4)",
  ];

  // 질문마다 다른 답변
  List<List<String>> _answers = [
    ["0 years", "1-3 years", "3-5 years", "5-7 years", "7+ years"],
    ["Yes,very much", "Yes somewhat", "neutral", "Not really", "Not at all"],
    [
      "Under 12 seconds",
      "12-15 seconds",
      "15-18 seconds",
      "18-22 seconds",
      "22+ seconds"
    ],
    [
      "Under 500 meters(Not yet)",
      "500-1000 meters",
      "1000-1500 meters",
      "Over 2000 meters"
    ],
  ];

  void _nextQuestion() {
    if (_selectedAnswerIndex != -1) {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _progressValue = (_currentQuestionIndex + 1) / _questions.length;
          _currentQuestionIndex++;
          _selectedAnswerIndex = -1; // Reset selection for the new question
        });
      } else {
        // 모든 질문에 답변 완료 후 완료 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CompletionScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}

class CompletionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ],
        ),
      ),
    );
  }
}
