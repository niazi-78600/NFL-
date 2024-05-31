import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nfl/main.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late String _displayText;

  @override
  void initState() {
    super.initState();
    _displayText = ''; // Initially, text is empty
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Adjust the duration as needed
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        // This function will be called on each animation tick
        setState(() {
          // Update the displayed text based on the current animation value
          _displayText = 'National Football League'.substring(
              0, (_animation.value * 'National Football League'.length).floor());
        });
      })
      ..addStatusListener((status) {
        // Navigate to home screen once animation completes
        if (status == AnimationStatus.completed) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002868),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('images/logoo.png'),
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 20), // Adding some space between the image and text
            Text(
              _displayText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
