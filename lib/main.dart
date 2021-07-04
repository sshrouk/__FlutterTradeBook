import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trade_book/provider/providerdata.dart';

import 'file:///F:/Shrouk%20Said%20Hassan%20Hassan/__FlutterTradeBook/trade_book/lib/login/welcomescreen.dart';

String language = 'EN';
bool darkMode = false;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((instance) {
    language = instance.getString('language');
    darkMode = instance.getBool('darkMode');
    runApp(TradeBook());
  });
}

class TradeBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProviderData>(
      create: (context) => ProviderData(),
      child: TradeBookWithTheme(),
    );
  }
}

class TradeBookWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ProviderData>(context);
    return GetMaterialApp(
      title: 'TradeBook',
      theme: theme.getTheme(),
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
