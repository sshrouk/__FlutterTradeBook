import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trade_book/mainPages/activities.dart';
import 'package:trade_book/provider/language.dart';

import '../provider/providerdata.dart';

class SubSectionPage extends StatefulWidget {

  @override
  _SubSectionPageState createState() => _SubSectionPageState();
}

class _SubSectionPageState extends State<SubSectionPage> {
  Language _language = Language();

  @override
  void initState() {
    super.initState();
    setState(() {
      _language.getLanguage();
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference sections = FirebaseFirestore.instance
        .collection('eMarket')
        .doc(sectionID(context))
        .collection('subsection');
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Image.asset(
              'images/screenTopShape.png',
              width: size.width,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: sections.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Something went wrong'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text('Loading'),
                    );
                  }
                  return ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                          String selectedLanguage() {
                            if (_language.getLanguage() == 'AR') {
                              return document.data()['NameAR'];
                            } else if (_language.getLanguage() == 'EN') {
                              return document.data()['NameEN'];
                            } else {
                              return document.data()['NameTR'];
                            }
                          }
                      return GestureDetector(
                        onTap: () {
                         setSubSectionID(context: context, val: document.id);
                          Get.to(() => ActivitiesPage());
                        },
                        child: ListTile(
                          title: Text(
                            selectedLanguage(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          leading: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: Image.network(document.data()['logoURL']),
                          ),
                          trailing: Icon(
                            Icons.arrow_right,
                            color: Colors.purple,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
