import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Container(
                child: LoadingAnimationWidget.halfTriangleDot(
                  size: 70.0,
                  color: Color(0xff1dbe92),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
