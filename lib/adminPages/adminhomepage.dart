import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trade_book/firebaseService.dart';

class AdminHomePage extends StatefulWidget {

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  FirebaseService _service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home Page'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Container(
        child: Center(
          child: MaterialButton(
            color: Colors.purple,
            textColor: Colors.white,
            child: Text('Send Data to FireStore'),
            onPressed: () {
              DocumentReference ref = _service.db
                  .collection(
                  'eMarket') //qsm el collection ll ktbth 3'lt sections-->eMarket
                  .doc('ProfessionalServices');
              ref.set({
              'logoURL':
              'https://firebasestorage.googleapis.com/v0/b/tradebook-7f850.appspot.com/o/logos%2FProfessionalServices.png?alt=media&token=421f6d6f-4bcd-4007-8e70-325fd192080f',
              'NameAR': 'خدمات مهنيه',
              'NameEN': 'Professional Service',
              'NameTR': 'Profesyonel servis',
              'createdAt':DateTime.now(),
              });

            },
          ),
        ),
      ),
    );
  }
}
