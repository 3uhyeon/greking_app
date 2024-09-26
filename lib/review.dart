import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_app/loading.dart';

class ReviewPage extends StatefulWidget {
  final String courseName;
  ReviewPage({required this.courseName});
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<dynamic> reviews = [];
  String _sortOption = 'latest';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    final url = 'http://43.203.197.86:8080/api/review/${widget.courseName}';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        setState(() {
          reviews = json.decode(response.body);
          isLoading = false;
        });
        _sortReviews(); // Sort after fetching
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      print('Error fetching reviews: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _sortReviews() {
    setState(() {
      if (_sortOption == 'latest') {
        reviews.sort((a, b) => b['reviewId'].compareTo(a['reviewId']));
      } else if (_sortOption == 'rating') {
        reviews.sort((a, b) => b['review_score'].compareTo(a['review_score']));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text('Course Reviews'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isLoading
          ? LoadingScreen()
          : reviews.isEmpty
              ? Center(
                  child: Text(
                    'No reviews yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 15.0),
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
                                color: _sortOption == 'latest'
                                    ? Colors.black
                                    : Colors.grey,
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
                                color: _sortOption == 'rating'
                                    ? Colors.black
                                    : Colors.grey,
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
                                          review['nickName'] ?? 'Anonymous',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          review['reviewId'].toString(),
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
                                          Icons.sentiment_satisfied,
                                          size: 40,
                                        ),
                                        SizedBox(width: 10),
                                        ...List.generate(
                                          5,
                                          (starIndex) {
                                            return Icon(
                                              Icons.star,
                                              color: starIndex <
                                                      review['review_score']
                                                  ? Color(0XFF1DBE92)
                                                  : Colors.grey,
                                              size: 20,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      review['review_text'] ??
                                          'No review provided',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Difficulty: ${review['review_difficulty'] ?? 'unknown'}',
                                      style: TextStyle(color: Colors.black54),
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
    home: ReviewPage(courseName: '1'),
    debugShowCheckedModeBanner: false,
  ));
}
