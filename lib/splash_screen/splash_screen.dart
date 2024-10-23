import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../authentication/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //function for set a timer
  startTimer() async {
    Timer(const Duration(seconds: 1), () {
      //for one time page view, no back button available in next page
      Get.off(() => const LoginScreen());

    });
  }

  @override
  void initState() {
    super.initState();
    //call the timer function when the state is initialized
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 200,
              height: 200,
            ),
            const SizedBox(
              height: 10,
            ),
            const CircularProgressIndicator(
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
