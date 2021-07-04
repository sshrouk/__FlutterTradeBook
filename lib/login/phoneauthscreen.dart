import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trade_book/components.dart';

import 'otpscreen.dart';

class PhoneAuthScreen extends StatefulWidget {

  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  TextEditingController _phoneTextController = TextEditingController();
  String gsn = 'phone Number';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 70),
                  child: Center(
                      child: Text(
                    'Phone Number',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  )),
                ),
                Container(
                  child: TextField(
                    onChanged: (val) {
                      setState(() {
                        if (val == '') {
                          gsn = 'Phone Number';
                        } else {
                          gsn = '+20$val';
                        }
                      });
                    },
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        hintText: 'Enter you phone number here',
                        prefix: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text('+20'),
                        )),
                    maxLength: 10,
                    controller: _phoneTextController,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RoundedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          OTPScreen(_phoneTextController.text)));
                },
                colour: Colors.teal[700],
                title: 'Verify',
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
