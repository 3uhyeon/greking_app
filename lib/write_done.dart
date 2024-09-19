import 'package:flutter/material.dart';
import 'package:my_app/main.dart';
import 'package:my_app/mycourse.dart';
import 'package:lottie/lottie.dart';

class WritingDoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/done.json'),
              Text(
                'Thank you for your Review!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainPage()));
                },
                child: Text('Go Greking',
                    style: TextStyle(color: Color(0xff0d615c))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
