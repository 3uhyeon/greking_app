import 'package:flutter/material.dart';
import 'package:my_app/main.dart';
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
              Text(
                'Booking Completed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 300),
                      pageBuilder: (_, __, ___) => MainPage(),
                      transitionsBuilder: (_, animation, __, child) {
                        Curve curve = Curves.fastEaseInToSlowEaseOut;
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                    ),
                  );
                  ;
                },
                child: Text('Go to Greking',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xff1dbe92), // Set the background color
                  minimumSize: Size(300, 45),

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
