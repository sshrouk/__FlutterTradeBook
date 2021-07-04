import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class ProviderData extends ChangeNotifier {
  ///ThemeChange
  ThemeData _themeData = darkMode ? ThemeData.dark() : ThemeData.light();

  getTheme() {
    return _themeData;
  }

  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }

  String sectionID = '';
  String subSectionID = '';
  String activityID = '';

  void setSectionID({@required String val}) {
    sectionID = val;
    notifyListeners();
  }

  void setSubSectionID({@required String val}) {
    subSectionID = val;
    notifyListeners();
  }

  void setActivityID({@required String val}) {
    activityID = val;
    notifyListeners();
  }
}

//write or edit sectionID
setSectionID({@required context, @required String val}) {
  Provider.of<ProviderData>(context, listen: false).setSectionID(val: val);
}

//read sectionID
String sectionID(context) {
  String sectionID =
      Provider.of<ProviderData>(context, listen: false).sectionID;
  return sectionID;
}

//----------------------------------------------------------------------------
//write or edit subSectionID
setSubSectionID({@required context, @required String val}) {
  Provider.of<ProviderData>(context, listen: false).setSubSectionID(val: val);
}

//read subSectionID
String subSectionID(context) {
  String subSectionID =
      Provider.of<ProviderData>(context, listen: false).subSectionID;
  return subSectionID;
}

//-----------------------------------------------------------------------------
//write or edit activitiesID
setActivitiesID({@required context, @required String val}) {
  Provider.of<ProviderData>(context, listen: false).setActivityID(val: val);
}

//read activitiesID
String activitiesID(context) {
  String activitiesID =
      Provider.of<ProviderData>(context, listen: false).activityID;
  return activitiesID;
}
