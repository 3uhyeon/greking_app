import 'package:flutter/material.dart';
import 'package:my_app/mycourse.dart';
import 'package:lottie/lottie.dart';

class BookingDoneScreen extends StatelessWidget {
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
                'Booking Completed!',
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
                child: Text('Go Greking',
                    style: TextStyle(color: Color(0xff0d615c))),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Set the background color

                  padding: EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16), // Set the button size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
