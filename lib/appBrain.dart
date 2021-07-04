import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'firebaseService.dart';

FirebaseService firebaseService = FirebaseService();

//Const:
final themeColor = Color(0xfff5a623);
final greyColor = Color(0xffaeaeae);
final greyColor2 = Color(0xffE8E8E8);
final String avatarPlaceholderURL =
    'https://www.google.com/imgres?imgurl=https%3A%2F%2Fwww.kindpng.com%2Fpicc%2Fm%2F78-785827_user-profile-avatar-login-account-male-user-icon.png&imgrefurl=https%3A%2F%2Fwww.kindpng.com%2Fimgv%2FobRJJT_user-profile-avatar-login-account-male-user-icon%2F&tbnid=OmyLfgFTjuk_qM&vet=12ahUKEwiojNyD4JfxAhVSw4UKHUWuCywQMygFegUIARCxAQ..i&docid=BJb3ZNagGqc-9M&w=860&h=887&q=profile%20avatar%20icon%20png%20profile%20user%20image&hl=ar&client=opera&ved=2ahUKEwiojNyD4JfxAhVSw4UKHUWuCywQMygFegUIARCxAQ';
const sCashedImg = 800;
const lCashedImg = 2000;

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

// OTP Consts:
final BoxDecoration pinPutDecoration = BoxDecoration(
  color: const Color.fromRGBO(43, 46, 66, 1),
  borderRadius: BorderRadius.circular(10.0),
  border: Border.all(
    color: const Color.fromRGBO(126, 203, 224, 1),
  ),
);
final TextEditingController pinPutController = TextEditingController();
final FocusNode pinPutFocusNode = FocusNode();

void launchWhatsApp(
    {@required String phone, @required String message, context}) async {
  String url() {
    if (Platform.isIOS) {
      return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
    } else {
      return "whatsapp://send?phone=$phone&text=$message";
    }
  }

  await canLaunch(url())
      ? launch(url())
      : Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.purple,
          content: Text('لم يتم العثور على تطبيق واتساب على جهازك !')));
}

sendMessage(String phone, String message) async {
  var uri = 'sms:$phone?body=$message';
  if (await canLaunch(uri)) {
    await launch(uri);
  } else {
    throw 'Could not launch $uri';
  }
}

String formattedDate(timeStamp) {
  var dateFromTimeStamp =
      DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
  return DateFormat('dd-MM-yyyy hh:mm a').format(dateFromTimeStamp);
}
