import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final List<Map<String, dynamic>> reviews = [
    {
      'name': 'Jenny',
      'date': '2024.08.06',
      'rating': 4.5,
      'review':
          'nice view and good weather. I had a great time with my friends. I would like to visit again next time.',
      'icon': Icons.sentiment_dissatisfied, // 기본 제공 아이콘 사용
    },
    {
      'name': 'Johnson',
      'date': '2024.08.06',
      'rating': 4.0,
      'review':
          'The trail was well maintained and the view was great. I was able to see the sunrise from the top of the mountain. It was a great experience.',
      'icon': Icons.sentiment_satisfied,
    },
    {
      'name': 'Minjune',
      'date': '2024.08.06',
      'rating': 4.5,
      'review':
          'so beautiful. I was able to see the sea of clouds. It was a great experience.',
      'icon': Icons.sentiment_very_satisfied,
    },
  ];

  String _sortOption = 'latest';

  void _sortReviews() {
    setState(() {
      if (_sortOption == 'latest') {
        reviews.sort((a, b) => b['date'].compareTo(a['date']));
      } else if (_sortOption == 'rating') {
        reviews.sort((a, b) => b['rating'].compareTo(a['rating']));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _sortReviews(); // 초기 정렬
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _sortOption = 'latest';
                      _sortReviews();
                    });
                  },
                  child: Text(
                    '    Latest',
                    style: TextStyle(
                      fontWeight: _sortOption == 'latest'
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color:
                          _sortOption == 'latest' ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _sortOption = 'rating';
                      _sortReviews();
                    });
                  },
                  child: Text(
                    'Rating',
                    style: TextStyle(
                      fontWeight: _sortOption == 'rating'
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color:
                          _sortOption == 'rating' ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                review['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Text(
                                review['date'],
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                review['icon'],
                                size: 40,
                              ),
                              SizedBox(width: 10),
                              ...List.generate(
                                5,
                                (starIndex) {
                                  return Icon(
                                    Icons.star,
                                    color: starIndex < review['rating']
                                        ? Color(0XFF1DBE92)
                                        : Colors.grey,
                                    size: 20,
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          SizedBox(height: 10),
                          Text(
                            review['review'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ReviewPage(),
    debugShowCheckedModeBanner: false,
  ));
}
