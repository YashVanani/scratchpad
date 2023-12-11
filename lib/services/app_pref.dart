
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class AppPref {
  static String isLanguageCode = 'LANGUAGE_CODE';
  static String isNoLanguage = 'noLanguage';

  static Future<Locale> setLanguageCode(String lCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(isLanguageCode, lCode);
    return Locale(lCode);
  }

  static Future<Locale> getLanguageCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString(isLanguageCode) ?? 'en';
    if(languageCode == 'en'){
      return const Locale('en');
    } else if(languageCode == 'hi'){
      return const Locale('hi');
    }  else {
      return const Locale('mr');
    }
  }
}