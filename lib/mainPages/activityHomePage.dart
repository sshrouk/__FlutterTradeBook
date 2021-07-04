import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:trade_book/firebaseService.dart';
import 'package:trade_book/homescreen.dart';
import 'package:trade_book/locationService.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components.dart';
import '../fUser.dart';
import '../provider/providerdata.dart';

class ActivityHomePage extends StatefulWidget {
  @override
  _ActivityHomePageState createState() => _ActivityHomePageState();
}

class _ActivityHomePageState extends State<ActivityHomePage> {
  FirebaseService _service = FirebaseService();
  String _logoURL = '';
  String _NameAR = '';
  String _whatsapp = '';
  double _latitude = 0;
  double _longitude = 0;
  LocationService _locationService = LocationService();

  @override
  void initState() {
    getActivityProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void follow(bool follow) {
      follow = !follow;
      if (follow) {
        DocumentReference ref = _service.db
            .collection('eMarket')
            .doc(sectionID(context))
            .collection('subsection')
            .doc(subSectionID(context))
            .collection('activities')
            .doc(activitiesID(context))
            .collection('followedUsers')
            .doc(auth.currentUser.uid);
        ref.set(
          {
            'logoURL': auth.currentUser.photoURL,
            'NameAR': auth.currentUser.displayName,
            'createDate': DateTime.now(),
          },
        );

        DocumentReference ref1 = _service.db
            .collection('users')
            .doc(auth.currentUser.uid)
            .collection('subscriptions')
            .doc(activitiesID(context));
        ref1.set(
          {
            'activityLogoURL': _logoURL,
            'activityName': _NameAR,
            'activitySection': sectionID(context),
            'activitySubSection': subSectionID(context),
            'createDate': DateTime.now(),
          },
        );
      } else {
        DocumentReference ref = _service.db
            .collection('eMarket')
            .doc(sectionID(context))
            .collection('subsection')
            .doc(subSectionID(context))
            .collection('activities')
            .doc(activitiesID(context))
            .collection('followedUsers')
            .doc(auth.currentUser.uid);
        ref.delete();

        DocumentReference ref1 = _service.db
            .collection('users')
            .doc(auth.currentUser.uid)
            .collection('subscriptions')
            .doc(activitiesID(context));
        ref1.delete();
      }
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.home,
          color: Colors.purple,
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          Get.offAll(() => HomeScreen());
        },
      ),
      body: Container(
        height: double.infinity,
        width: size.width,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Image.asset(
                'images/screenTopShape.png',
                width: size.width,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: Column(
                children: [
                  Text(
                    _NameAR,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        image: new DecorationImage(
                          fit: BoxFit.contain,
                          image: NetworkImage(_logoURL),
                        )),
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('eMarket')
                            .doc(sectionID(context))
                            .collection('subsection')
                            .doc(subSectionID(context))
                            .collection('activities')
                            .doc(activitiesID(context))
                            .collection('likedUsers')
                            .doc(auth.currentUser.uid)
                            .snapshots(),
                        builder: (BuildContext context, snapshots) {
                          if (!snapshots.hasData) {
                            return Center(
                              child: Icon(FontAwesomeIcons.heart),
                            );
                          }
                          if (snapshots.data.exists) {
                            return IconButton(
                              icon: Icon(FontAwesomeIcons.solidHeart),
                              onPressed: () {
                                addLike(true);
                              },
                              color: Colors.red,
                            );
                          } else {
                            return IconButton(
                              icon: Icon(FontAwesomeIcons.heart),
                              onPressed: () {
                                addLike(false);
                              },
                              color: Colors.grey,
                            );
                          }
                        },
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('eMarket')
                            .doc(sectionID(context))
                            .collection('subsection')
                            .doc(subSectionID(context))
                            .collection('activities')
                            .doc(activitiesID(context))
                            .collection('likedUsers')
                            .snapshots(),
                        builder: (BuildContext context, snapshots) {
                          if (snapshots.hasData) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child:
                                  Text(snapshots.data.docs.length.toString()),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text('0'),
                            );
                          }
                        },
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          icon: Icon(
                            Icons.add_comment,
                            color: Colors.teal,
                          ),
                          onPressed: () {}),
                      Text('التعليقات'),
                      Expanded(child: Container()),
                      IconButton(
                          icon: Icon(
                            Icons.attachment_rounded,
                            color: Colors.red,
                          ),
                          onPressed: () {}),
                      Text('0'),
                      Expanded(child: Container()),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              child: Row(
                                children: [
                                  CustomCard(
                                    onPressed: () {
                                      _locationService
                                          .sendLocationToDataBase(context);
                                      _locationService.goToMap(
                                          _latitude, _longitude);
                                    },
                                    iconSize:
                                        MediaQuery.of(context).size.width * 0.2,
                                    icon: FontAwesomeIcons.searchLocation,
                                    txt: ' الموقع ',
                                    iconColor: Colors.red,
                                  ),
                                  CustomCard(
                                    onPressed: () {},
                                    iconSize:
                                        MediaQuery.of(context).size.width * 0.2,
                                    icon: FontAwesomeIcons.store,
                                    txt: ' المتجر ',
                                    iconColor: Colors.blueAccent,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Row(
                                children: [
                                  CustomCard(
                                    onPressed: () {},
                                    iconSize:
                                        MediaQuery.of(context).size.width * 0.2,
                                    icon: FontAwesomeIcons.photoVideo,
                                    txt: ' المعرض ',
                                    iconColor: Colors.deepOrange,
                                  ),
                                  CustomCard(
                                    onPressed: () {
                                      sendWhatsAppMessage(_whatsapp,
                                          'مرحبا $_NameAR من تطبيق تريدبوك');
                                    },
                                    iconSize:
                                        MediaQuery.of(context).size.width * 0.2,
                                    icon: FontAwesomeIcons.whatsapp,
                                    txt: ' اتصل بنا ',
                                    iconColor: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.contain,
                    image: NetworkImage(_logoURL),
                  )),
              child: Positioned(
                bottom: 0,
                left: 0,
                child: Text(
                  _NameAR,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  'Facebook',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                leading: Icon(
                  FontAwesomeIcons.facebook,
                  color: Colors.blue,
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  color: Colors.purple,
                ),
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  'Twitter',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                leading: Icon(
                  FontAwesomeIcons.twitter,
                  color: Colors.blue,
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  color: Colors.purple,
                ),
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  'Youtube',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                leading: Icon(
                  FontAwesomeIcons.youtube,
                  color: Colors.red,
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  color: Colors.purple,
                ),
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  'Instagram',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                leading: Icon(
                  FontAwesomeIcons.instagram,
                  color: Colors.deepOrange,
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  color: Colors.purple,
                ),
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  'Site',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                leading: Icon(
                  FontAwesomeIcons.calendarCheck,
                  color: Colors.deepPurple,
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  color: Colors.purple,
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  getActivityProfile() async {
    DocumentReference ref = _service.db
        .collection('eMarket')
        .doc(sectionID(context))
        .collection('subsection')
        .doc(subSectionID(context))
        .collection('activities')
        .doc(activitiesID(context));
    ref.get().then(
          (doc) => {
            setState(() {
              if (doc.data() != null) {
                _logoURL = doc.data()['logoURL'] ??= '';
                _NameAR = doc.data()['NameAR'] ??= 'Activity Name';
                _whatsapp = doc.data()['whatsapp'] ??= '+201227354021';
                _latitude = doc.data()['latitude'] ??= 0;
                _longitude = doc.data()['longitude'] ??= 0;
              }
            })
          },
        );
  }

  void addLike(bool liked) {
    liked = !liked;
    if (liked) {
      DocumentReference ref = _service.db
          .collection('eMarket')
          .doc(sectionID(context))
          .collection('subsection')
          .doc(subSectionID(context))
          .collection('activities')
          .doc(activitiesID(context))
          .collection('likedUsers')
          .doc(auth.currentUser.uid);
      ref.set({
        'logoURL': auth.currentUser.photoURL,
        'NameAR': auth.currentUser.displayName,
        'createDate': DateTime.now(),
      });
    } else {
      DocumentReference ref = _service.db
          .collection('eMarket')
          .doc(sectionID(context))
          .collection('subsection')
          .doc(subSectionID(context))
          .collection('activities')
          .doc(activitiesID(context))
          .collection('likedUsers')
          .doc(auth.currentUser.uid);
      ref.delete();
    }
  }

  sendWhatsAppMessage(@required String phone, @required String message) async {
    String url() {
      if (Platform.isIOS) {
        return 'whatsapp://wa.me/$phone/?text=${Uri.parse(message)}';
      } else {
        return 'whatsapp://send?phone=$phone&text=$message';
      }
    }

    await canLaunch(url())
        ? launch(url())
        : Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('There is no Whatsapp on your device')));
  }
}
