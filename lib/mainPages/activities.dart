import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trade_book/mainPages/activityHomePage.dart';

import '../provider/providerdata.dart';

class ActivitiesPage extends StatefulWidget {

  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference sections = FirebaseFirestore.instance
        .collection('eMarket')
        .doc(sectionID(context))
        .collection('subsection')
        .doc(subSectionID(context))
        .collection('activities');
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
                      return GestureDetector(
                        onTap: () {
                          setActivitiesID(context: context, val: document.id);
                          Get.to(()=>ActivityHomePage());
                        },
                        child: ListTile(
                          title: Text(
                            document.data()['NameAR'],
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
