import 'package:flutter/material.dart';
import 'package:my_app/mycourse.dart';

class BookingDoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
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
              child: Text('Go Greking'),
            ),
          ],
        ),
      ),
    );
  }
}
