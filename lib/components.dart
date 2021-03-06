import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'appBrain.dart';

class RoundIconButton extends StatelessWidget {
  RoundIconButton(
      {@required this.icon,
      @required this.onPressed,
      this.iconColor,
      this.buttonColor});

  final IconData icon;
  final Function onPressed;
  final iconColor;
  final buttonColor;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        icon,
        color: iconColor,
      ),
      onPressed: onPressed,
      elevation: 0.0,
      constraints: BoxConstraints.tightFor(
        width: 56.0,
        height: 56.0,
      ),
      shape: CircleBorder(),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      fillColor: buttonColor,
    );
  }
}

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {this.colour,
      this.title,
      @required this.onPressed,
      this.textColor,
      this.buttonIcon,
      this.iconColor});

  final Color colour;
  final Color textColor;
  final Color iconColor;
  final String title;
  final Function onPressed;
  final buttonIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Icon(
                buttonIcon,
                color: iconColor,
              ),
            ),
            MaterialButton(
              onPressed: () {
                onPressed();
              },
              minWidth: 1000.0,
              height: 42.0,
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Playfair',
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedPinPut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: PinPut(
        fieldsCount: 6,
        textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
        eachFieldWidth: 40.0,
        eachFieldHeight: 55.0,
        focusNode: pinPutFocusNode,
        controller: pinPutController,
        submittedFieldDecoration: pinPutDecoration,
        selectedFieldDecoration: pinPutDecoration,
        followingFieldDecoration: pinPutDecoration,
        pinAnimationType: PinAnimationType.fade,
        onSubmit: (pin) async {
          firebaseService.verifyOTP(context, pin);
        },
      ),
    );
  }
}

class UserRoundedPic extends StatelessWidget {
  UserRoundedPic(
      {@required this.photoSize,
      @required this.onPressed,
      @required this.image});

  final photoSize;
  final Function onPressed;
  final image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: photoSize,
          height: photoSize,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.cover,
              image: image,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 90),
          child: IconButton(
            icon: Icon(Icons.camera_alt),
            iconSize: 37,
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  CustomCard({
    this.backgroundColor,
    @required this.onPressed,
    @required this.iconSize,
    @required this.icon,
    @required this.txt,
    this.iconColor,
  });

  final Function onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final double iconSize;
  final String txt;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () => onPressed(),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              IconButton(
                icon: Icon(icon),
                onPressed: onPressed,
                iconSize: iconSize,
                color: iconColor,
              ),
              Spacer(),
              Text(
                txt,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: iconSize / 3,
                    fontFamily: 'AB_Zar'),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    ));
  }
}
