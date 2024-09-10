import 'package:flutter/material.dart';

class ReviewWritingPage extends StatefulWidget {
  const ReviewWritingPage({Key? key}) : super(key: key);
  @override
  _ReviewWritingPageState createState() => _ReviewWritingPageState();
}

class _ReviewWritingPageState extends State<ReviewWritingPage> {
  int _selectedStar = 0;
  int _selectedDifficulty = -1;
  final TextEditingController _reviewController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: IconButton(
          icon: Icon(Icons.close),
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
              // 닉네임 및 지역명
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
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
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.0),

              // 별점 등록
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

              // 난이도 선택
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

              // 리뷰 작성
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
                  hintText: 'Write your review here in 200 characters',
                  hintStyle: TextStyle(color: Color(0xFFA9B0B5)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 50.0),

              // 등록 버튼
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // 리뷰 등록 로직 추가
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFF1DBE92),
                    padding: EdgeInsets.symmetric(
                        horizontal: 130, vertical: 15), // Adjust the width here
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

  Widget _buildDifficultyButton(int index, String label, IconData icon) {
    return GestureDetector(
      onTap: () => _selectDifficulty(index),
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: _selectedDifficulty == index
              ? Color(0XFF1DBE92)
              : Colors.grey[200],
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
