import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trade_book/provider/language.dart';
import 'package:trade_book/provider/providerdata.dart';

import 'subSectionPage.dart';

class SectionPage extends StatefulWidget {
  @override
  _SectionPageState createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
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

    CollectionReference sections =
        FirebaseFirestore.instance.collection('eMarket');
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: sections.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              children: snapshot.data.docs.map((DocumentSnapshot document) {
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
                    setSectionID(context: context, val: document.id);
                    Get.to(() => SubSectionPage());
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(size.width / 5)),
                    child: CachedNetworkImage(
                      imageUrl: document.data()['logoURL'],
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
          },
        ),
      ),
    );
  }
}
