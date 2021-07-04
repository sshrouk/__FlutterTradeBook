import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:trade_book/adminPages/adminhomepage.dart';
import 'package:trade_book/mainPages/jobsPage.dart';
import 'package:trade_book/mainPages/showCasePage.dart';
import 'package:trade_book/mainPages/subscriptionPage.dart';
import 'package:trade_book/settingsScreen.dart';
import 'package:trade_book/userProfileScreen.dart';

import 'appBrain.dart';
import 'mainPages/sectionPage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int access = 0;
  int _index = 0;
  final List<Widget> _pages = [
    SectionPage(),
    ShowCasePage(),
    SubscriptionPage(),
    JobsPage(),
  ];
  String _userImageUrl = avatarPlaceholderURL;
  String _displayedName = 'User Name';

  @override
  void initState() {
    // getUserProfile();
    setState(() {
      _index = 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.purple,
                      Colors.deepPurple,
                    ]),
                  ),
                  child: CircleAvatar(
                    child: Image.network(_userImageUrl),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      _displayedName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: Icon(
                      FontAwesomeIcons.user,
                      color: Colors.purple,
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Colors.purple,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => UserProfileScreen());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      'Notification',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: Icon(
                      FontAwesomeIcons.bell,
                      color: Colors.purple,
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
                      'Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: Icon(
                      Icons.settings,
                      color: Colors.purple,
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Colors.purple,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => SettingsScreen());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: Icon(
                      FontAwesomeIcons.signOutAlt,
                      color: Colors.purple,
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
          endDrawer: Drawer(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50, right: 15),
                  child: GestureDetector(
                    onTap: () {
                      access++;
                      if (access == 5) {
                        access = 0;
                        Navigator.pop(context);
                        Get.to(() => AdminHomePage());
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage('images/appstore.png'),
                          ),
                        ),
                        Center(
                          child: Text(
                            'TradeBook',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
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
          body: Container(
            height: size.height,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  child: Image.asset(
                    'images/screenTopShape.png',
                    width: size.width,
                  ),
                ),
                _pages[_index],
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 23),
                      child: IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            scaffoldKey.currentState.openEndDrawer();
                          }),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 23),
                      child: IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            scaffoldKey.currentState.openDrawer();
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: CurvedNavigationBar(
            color: Colors.purple,
            backgroundColor: Colors.white,
            height: 50,
            animationDuration: Duration(milliseconds: 200),
            items: [
              Icon(
                Icons.home,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                FontAwesomeIcons.windows,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.subscriptions,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.work,
                size: 30,
                color: Colors.white,
              ),
            ],
            onTap: (index) {
              setState(() {
                _index = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
