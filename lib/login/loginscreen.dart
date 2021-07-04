import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:trade_book/login/phoneauthscreen.dart';

import '../components.dart';
import '../firebaseService.dart';
import '../homescreen.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseService firebaseService = FirebaseService();

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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'images/appstore.png',
                      width: size.width * 0.5,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: Text(
                    'Login With',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  RoundedButton(
                    onPressed: () {
                      Get.to(()=>PhoneAuthScreen());
                    },
                    title: 'Phone sign in',
                    textColor: Colors.white,
                    buttonIcon: Icons.phone,
                    colour: Colors.green,
                    iconColor: Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RoundedButton(
                    onPressed: () {
                      firebaseService.googleSignIn(context);
                    },
                    title: 'Google sign in',
                    textColor: Colors.blue,
                    colour: Colors.white,
                    buttonIcon: FontAwesomeIcons.google,
                    iconColor: Colors.blue,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                      onPressed: () {
                        Get.to(()=>HomeScreen());
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
