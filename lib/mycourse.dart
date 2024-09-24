import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:http/http.dart' as http;
import 'package:my_app/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'review_write.dart';
import 'gpx_treking.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Course',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyCourse(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyCourse extends StatefulWidget {
  const MyCourse({super.key});

  @override
  _MyCourseState createState() => _MyCourseState();
}

class _MyCourseState extends State<MyCourse>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> expectedCourses = [];
  List<dynamic> completedCourses = [];
  bool isLoading = true;
  final String _url = 'http://43.203.197.86:8080';
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('uid');
      print(userId);
      final expectedResponse = await http.get(
        Uri.parse(_url + '/api/users/$userId/my-courses/expected'),
      );

      // Fetch completed courses
      final completedResponse = await http.get(
        Uri.parse(_url + '/api/users/$userId/my-courses/complete'),
      );

      if (expectedResponse.statusCode == 200 &&
          completedResponse.statusCode == 200) {
        setState(() {
          expectedCourses = json.decode(expectedResponse.body);
          completedCourses = json.decode(completedResponse.body);
          isLoading = false;
        });
      } else {
        print('Failed to fetch courses');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteCourse(int userCourseId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('uid');

    final deleteResponse = await http.delete(
      Uri.parse(_url + '/api/users/$userId/my-courses/$userCourseId'),
    );

    if (deleteResponse.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text('Course deleted'),
        ),
      );
      fetchCourses(); // Refresh the course list after deletion
    } else {
      print('Failed to delete course');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leading: Container(),
        leadingWidth: 0,
        title: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pretendard',
          ),
          unselectedLabelColor: Colors.grey,
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            fontFamily: 'Pretendard',
          ),
          dividerColor: Colors.transparent,
          indicatorColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'Scheduled to Climb'),
            Tab(text: 'Climb Completed'),
          ],
        ),
      ),
      body: isLoading
          ? LoadingScreen()
          : TabBarView(
              controller: _tabController,
              children: [
                buildHikingList(courses: expectedCourses),
                buildHikingList(courses: completedCourses, isCompleted: true),
              ],
            ),
    );
  }

  Widget buildHikingList(
      {required List<dynamic> courses, bool isCompleted = false}) {
    if (courses.isEmpty) {
      return Center(
        child: Text(
          'No courses available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return buildHikingCard(context,
            course: courses[index], isCompleted: isCompleted);
      },
    );
  }

  Widget buildHikingCard(BuildContext context,
      {required dynamic course, bool isCompleted = false}) {
    var courseInfo = course['course'];
    var courseName = courseInfo['courseName'];
    var mountainName = courseInfo['mountainName'];
    var duration = courseInfo['duration'];
    var difficulty = courseInfo['difficulty'];
    var addedTime = course['addedTime'];
    var userCourseId = course['userCourseId'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 4.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '  Reserved $addedTime ',
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400),
              ),
              const Spacer(),
              isCompleted
                  ? Container()
                  : PopupMenuButton(
                      constraints: const BoxConstraints(
                        minWidth: 50,
                        maxWidth: 100,
                      ),
                      color: Colors.white,
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == 'delete') {
                          deleteCourse(userCourseId);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'delete',
                          child: Container(
                            color: const Color(0xffEBEFF2),
                            child: Row(
                              children: const [
                                Icon(Icons.delete, color: Colors.red, size: 20),
                                SizedBox(width: 10),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      offset: const Offset(0, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset('assets/image.png',
                    width: 100, height: 80, fit: BoxFit.cover),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$courseName'.replaceAll('_', ' '),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff0d615c),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(Icons.directions_walk,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4.0),
                        Text(
                          duration ?? '',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Icon(Icons.terrain, size: 16, color: Colors.grey),
                        const SizedBox(width: 4.0),
                        Text(
                          difficulty ?? '',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          isCompleted
              ? Center(
                  child: SizedBox(
                  width: 390,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor: Color(0xff1DBE92),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => ReviewWritingPage(
                              courseName: course['course']['courseName'],
                              userCourseId:
                                  int.parse(course['userCourseId'].toString())),
                          transitionsBuilder:
                              (_, Animation<double> animation, __, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Write a Review',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ))
              : Center(
                  child: SizedBox(
                    width: 390,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        backgroundColor: Color(0xff1DBE92),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => TrackingPage(
                                courseName: course['courseName'],
                                userCourseId: course['userCourseId']),
                            transitionDuration: Duration(milliseconds: 100),
                            transitionsBuilder:
                                (_, Animation<double> animation, __, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 1),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'Go to the Course',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
