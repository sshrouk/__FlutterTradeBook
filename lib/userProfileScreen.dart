import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:get/get.dart';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:trade_book/appBrain.dart';
import 'package:trade_book/components.dart';
import 'package:trade_book/firebaseService.dart';

import 'fUser.dart';

class UserProfileScreen extends StatefulWidget {
  static const id = 'UserProfileScreen';

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  GlobalKey _barcodekey = new GlobalKey();
  FirebaseService _service = FirebaseService();
  String userImageURL;

  File _image;
  final picker = ImagePicker();
  bool _uploading = false;
  TextEditingController _displayNameTETController = TextEditingController();
  TextEditingController _emailTETController = TextEditingController();
  TextEditingController _phoneTETController = TextEditingController();
  bool _editing = false;

  @override
  void initState() {
    getUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('UserProfile'),
          centerTitle: true,
          backgroundColor: Colors.purple,
          actions: [
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  _shareWidgetAsImage();
                })
          ],
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    IconButton(
                        icon: !_editing
                            ? Icon(
                                Icons.edit,
                                color: Colors.purple,
                              )
                            : Icon(
                                Icons.save,
                                color: Colors.purpleAccent,
                              ),
                        onPressed: () {
                          setState(() {
                            updateUserProfile();
                            _editing = !_editing;
                          });
                        }),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Center(
                            child: _image == null
                                ? UserRoundedPic(
                                    photoSize: 130.0,
                                    onPressed: () {
                                      getImageFromGallery();
                                    },
                                    image: NetworkImage(
                                        userImageURL ??= avatarPlaceholderURL),
                                  )
                                : UserRoundedPic(
                                    photoSize: 130.0,
                                    onPressed: () {
                                      getImageFromGallery();
                                    },
                                    image: FileImage(_image),
                                  ),
                          ),
                        ),
                        _uploading == true
                            ? CircularProgressIndicator()
                            : Container(),
                        !_editing
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _displayNameTETController.text,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 28),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Display Name',
                                    hintText: 'Enter Your Display Name here',
                                  ),
                                  controller: _displayNameTETController,
                                ),
                              ),
                        !_editing
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _emailTETController.text,
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 25),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'E-Mail',
                                    hintText: 'Enter Your email here',
                                  ),
                                  controller: _emailTETController,
                                ),
                              ),
                        !_editing
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _phoneTETController.text,
                                  style: TextStyle(
                                      color: Colors.blueGrey, fontSize: 23),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    hintText: 'Enter Your phone number here',
                                  ),
                                  controller: _phoneTETController,
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
                RepaintBoundary(
                  key: _barcodekey,
                  child: BarcodeWidget(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 2,
                      color: Colors.purple[700],
                      data: auth.currentUser.uid,
                      barcode: Barcode.qrCode()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      uploadAndUpdate();
    } else {
      print('No image selected');
    }
  }

  _shareWidgetAsImage() async {
    try {
      RenderRepaintBoundary boundary =
          _barcodekey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 5.0);

      ByteData bytoData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      var pngBytes = bytoData.buffer.asUint8List();
      String dir = (await getApplicationDocumentsDirectory()).path;

      File file =
          File("$dir/" + DateTime.now().millisecondsSinceEpoch.toString());
      await file.writeAsBytes(pngBytes);
      Share.shareFiles([file.path],
          text: 'TradeBook User : ${_displayNameTETController.text}');

      //awln b7wl l image  then var data -> png  then var directoy then b7wlha l file b3d kda share l mlf
    } catch (e) {
      print(e);
    }
  }

  uploadAndUpdate() async {
    setState(() {
      _uploading = true;
    });
    final _storage = FirebaseStorage.instance;
    var file = File(_image.path);
    var snapshot = await _storage
        .ref()
        .child('usersPhotos/${auth.currentUser.uid}')
        .putFile(file)
        .whenComplete(
          () => {
            setState(() => _uploading = false),
            print('Upload Completed Successfully'),
          },
        );
    var downloadURL = await snapshot.ref.getDownloadURL();
    DocumentReference ref =
        _service.db.collection('users').doc(auth.currentUser.uid);
    ref.update(
      {
        'photoUrl': downloadURL,
      },
    );
  }

  getUserProfile() async {
    DocumentReference ref =
        _service.db.collection('users').doc(auth.currentUser.uid);
    ref.get().then((doc) => {
          setState(() {
            if (doc.data() != null) {
              userImageURL = doc.data()['photoUrl'];
              _displayNameTETController.text = doc.data()['displayName'];
              _emailTETController.text = doc.data()['email'];
              _phoneTETController.text = doc.data()['phone'];
            }
          })
        });
  }

  updateUserProfile() async {
    if (_editing == true) {
      DocumentReference ref =
          _service.db.collection('users').doc(auth.currentUser.uid);
      ref.update(
        {
          'displayName': _displayNameTETController.text,
          'email': _emailTETController.text,
          'phone': _phoneTETController.text,
        },
      );
    }
  }
}
