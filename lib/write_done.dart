import 'package:flutter/material.dart';
import 'package:my_app/mycourse.dart';
import 'package:lottie/lottie.dart';

class WritingDoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/done.json'),
              SizedBox(height: 16),
              Text(
                'Thank you for your Review!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyCourse()));
                },
                child: Text('Go Greking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
