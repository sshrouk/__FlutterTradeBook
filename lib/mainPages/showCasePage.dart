import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trade_book/provider/language.dart';
import 'package:trade_book/provider/providerdata.dart';

import 'activityHomePage.dart';

class ShowCasePage extends StatefulWidget {
  @override
  _ShowCasePageState createState() => _ShowCasePageState();
}

class _ShowCasePageState extends State<ShowCasePage> {
  Language _language = Language();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var ref = FirebaseFirestore.instance
        .collection('showcase')
        .where('country', isEqualTo: 'Turkey')
        .where('city', isEqualTo: 'Mersin');
    return Padding(
      padding: const EdgeInsets.only(top: 68),
      child: Container(
        child: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
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
                  return GridView.count(
                    crossAxisCount: 2,
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
                          setSectionID(
                              context: context,
                              val: document.data()['activitySection']);
                          setSubSectionID(
                              context: null,
                              val: document.data()['activitySubSection']);
                          Get.to(() => ActivityHomePage());
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(size.width / 5)),
                          child: CachedNetworkImage(
                            imageUrl: document.data()['activityLogoURL'],
                            placeholder: (context, url) => Center(
                              child: Text('. . .'),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Text('err'),
                            ),
                            imageBuilder: (context, imageProvider) => Container(
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.white,
                                    backgroundImage: imageProvider,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      selectedLanguage(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'XB_Zar',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
