import 'package:flutter/material.dart';
import 'package:my_app/loading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewDetailPage extends StatefulWidget {
  const ReviewDetailPage({Key? key}) : super(key: key);

  @override
  _ReviewDetailPageState createState() => _ReviewDetailPageState();
}

class _ReviewDetailPageState extends State<ReviewDetailPage> {
  List<dynamic> reviews = [];
  bool isLoading = false;
  bool isLatestSort = true; // 최신순 여부

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('http://43.203.197.86:8080/api/review/all'),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          reviews = json.decode(response.body);
          reviews = reviews.reversed.toList(); // 최신순으로 정렬
          isLoading = false;
        });
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

  // 리뷰를 별점순으로 정렬
  void _sortByRating() {
    setState(() {
      reviews.sort(
          (a, b) => (b['review_score'] ?? 0).compareTo(a['review_score'] ?? 0));
      isLatestSort = false;
    });
  }

  // 리뷰를 최신순으로 정렬
  void _sortByLatest() {
    setState(() {
      reviews = reviews.reversed.toList(); // 최신순으로 정렬
      isLatestSort = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingScreen();
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          title: Text(
            'Review Detail',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Pretendard',
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 정렬 버튼 추가
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _sortByLatest,
                      child: Text(
                        'Latest',
                        style: TextStyle(
                          color: isLatestSort ? Colors.black : Colors.grey,
                          fontWeight: isLatestSort
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _sortByRating,
                      child: Text(
                        'Rating',
                        style: TextStyle(
                          color: !isLatestSort ? Colors.black : Colors.grey,
                          fontWeight: !isLatestSort
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                // 리뷰 리스트 출력
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: reviews.isEmpty
                      ? [
                          Text('No reviews yet',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                        ]
                      : reviews
                          .map((review) => _buildReviewCard(review))
                          .toList(),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildReviewCard(dynamic review) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                review['review_difficulty'] == 'easy'
                    ? Icons.sentiment_very_satisfied
                    : review['review_difficulty'] == 'manageable'
                        ? Icons.sentiment_satisfied
                        : Icons.sentiment_dissatisfied,
                size: 35,
              ),
              SizedBox(width: 8),
              Text(
                review['nickname'] ?? 'Anonymous',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard',
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                review['courseName'] ?? 'Unknown Course',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index < review['review_score'] ? Icons.star : Icons.star_border,
                size: 16,
                color: Colors.amber,
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            review['review_text'] ?? 'No review provided',
            style: TextStyle(color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12),
          Text(
            'Difficulty: ${review['review_difficulty'] ?? 'unknown'}',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
