import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../homescreen.dart';
import 'loginscreen.dart';

class WelcomeScreen extends StatefulWidget {

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      if (_auth.currentUser != null) {
        Get.to(()=>HomeScreen());
      } else {
        Get.to(()=>LoginScreen());      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          height: size.height,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  'images/main_top.png',
                  width: size.width * 0.4,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  'images/main_bottom.png',
                  width: size.width * 0.3,
                ),
              ),
              Center(
                child: Image.asset(
                  'images/appstore.gif',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
