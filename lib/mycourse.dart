import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pretendard',
          ),
          unselectedLabelColor: Colors.grey,
          unselectedLabelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            fontFamily: 'Pretendard',
          ),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          indicatorColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'Scheduled to Climb'),
            Tab(text: 'Climb Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildHikingList(),
          buildHikingList(isCompleted: true),
        ],
      ),
    );
  }

  Widget buildHikingList({bool isCompleted = false}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 5,
      itemBuilder: (context, index) {
        return buildHikingCard(context, isCompleted: isCompleted);
      },
    );
  }

  Widget buildHikingCard(BuildContext context, {bool isCompleted = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0XFFEBEFF2),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
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
          Text(
            '24.07.06 (Th)',
            style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400),
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
                      'MT. MinJune',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Icon(Icons.directions_walk,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4.0),
                        Text(
                          '3h 40m ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Icon(Icons.wb_sunny, size: 16, color: Colors.grey),
                        const SizedBox(width: 4.0),
                        Text(
                          'Sunny',
                          style: TextStyle(
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
          SizedBox(
            height: 10,
          ),
          isCompleted
              ? Center(
                  child: SizedBox(
                  width: 390,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => ReviewWritingPage(),
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
                        color: Color(0XFF1DBE92),
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
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrackingPage()),
                        );
                      },
                      child: Text(
                        'Go to the Course',
                        style: TextStyle(
                          color: Color(0xff1dbe92),
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
