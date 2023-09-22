import 'dart:async';

import 'package:flutter/material.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    Timer(const
      Duration(seconds: 4), 
      () => Navigator.pushReplacement(
        context, MaterialPageRoute(
          builder: (context) => const MyLoginScreen()
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Center(
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/skill_hands_logo.jpg', 
                width: 100.0,
                height: 100.0, 
              ),
              const SizedBox(height: 30.0),
              const Text(
                'Skill Hands', 
                style: TextStyle(
                  fontSize: 20.0, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xff6C62FE),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}