import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../appBrain.dart';

class JobsPage extends StatefulWidget {
  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('jobs')
        .orderBy('date', descending: true);

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: ref.snapshots(),
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
                      return Card(
                        color: document.data()['available']
                            ? Colors.white
                            : Colors.white70,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            ListTile(
                                title: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    document.data()['jobTitle'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(color: Colors.blue),
                                  ),
                                ),
                                subtitle: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(
                                    document.data()['jobDescription'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                            color:
                                                document.data()['highlighted']
                                                    ? Colors.red
                                                    : Colors.black,
                                            fontWeight:
                                                document.data()['highlighted']
                                                    ? FontWeight.bold
                                                    : FontWeight.normal),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white70,
                                  backgroundImage: NetworkImage(
                                      document.data()['activityLogoURL']),
                                )),
                            Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    document.data()['activityName'],
                                    style: TextStyle(color: Colors.black38),
                                  ),
                                )),
                            Container(
                              child: Row(
                                children: [
                                  SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(formattedDate(
                                            document.data()['date'])),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  document.data()['available']
                                      ? InkWell(
                                          onTap: () {
                                            sendMessage(
                                                document.data()['phone'],
                                                'مرحباً ${document.data()['activityName']} من تطبيق تريدبوك أريد الاستفسار عن إعلان العمل ${document.data()['jobDescription']}');
                                          },
                                          child: Icon(
                                            Icons.message,
                                            color: Colors.amber,
                                          ),
                                        )
                                      : Container(),
                                  Spacer(),
                                  document.data()['available']
                                      ? InkWell(
                                          onTap: () {
                                            launch(
                                                'tel://${document.data()['phone']}');
                                          },
                                          child: Icon(
                                            Icons.phone,
                                            color: Colors.teal,
                                          ),
                                        )
                                      : Container(),
                                  Spacer(),
                                  document.data()['available']
                                      ? InkWell(
                                          onTap: () {
                                            launchWhatsApp(
                                                phone: document.data()['phone'],
                                                message:
                                                    'مرحباً ${document.data()['activityName']} من تطبيق تريدبوك أريد الاستفسار عن إعلان العمل ${document.data()['jobDescription']}');
                                          },
                                          child: Icon(
                                            FontAwesomeIcons.whatsappSquare,
                                            color: Colors.teal,
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(width: 15),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/screenTopShape.png',
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }
}
