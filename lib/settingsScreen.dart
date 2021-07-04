import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trade_book/provider/language.dart';

import 'main.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Language _language = Language();
  List<String> _languages = ['AR', 'EN', 'TR'];
  String _selectedLanguage;
  bool _darkMode = false;
  bool _notifications = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _language.getLanguage();
    });
    setState(() {
      _darkMode = darkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.purple),
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.purple,
                margin: const EdgeInsets.all(0),
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 33,
                  ),
                  title: Text(
                    _language.tSettings(),
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  ListTile(
                    title: Text(_language.tChangeLanguage()),
                    leading: Icon(
                      FontAwesomeIcons.language,
                      color: Colors.purple,
                    ),
                    trailing: DropdownButton(
                        hint: Text(_language.tLanguage()),
                        value: _selectedLanguage,
                        onChanged: (newValue) async {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setString('language', newValue);
                          _language.setLanguage(newValue);
                          language = newValue;
                          setState(() {
                            _selectedLanguage = newValue;
                          });
                        },
                        items: _languages.map((lang) {
                          return DropdownMenuItem(
                            child: new Text(lang),
                            value: lang,
                          );
                        }).toList()),
                  ),
                  ListTile(
                    title: Text(_language.tDarkMode()),
                    leading: Icon(
                      FontAwesomeIcons.brush,
                      color: Colors.black,
                    ),
                    trailing: Switch(
                      activeColor: Colors.teal,
                      value: _darkMode,
                      onChanged: (val) async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.setBool('darkMode', val);

                        setState(() {
                          _darkMode = val;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(_language.tReceiveNotifications()),
                    leading: Icon(
                      FontAwesomeIcons.bell,
                      color: Colors.red,
                    ),
                    trailing: Switch(
                      activeColor: Colors.teal,
                      value: _notifications,
                      onChanged: (val) async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.setBool('notifications', val);

                        setState(() {
                          _notifications = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//Functions:

}
