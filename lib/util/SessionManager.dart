import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String USER_TYPE = 'userType';
  static const String USER_ID = 'userId';
  static const String FULL_NAME = 'userName';
  static const String FIRST_NAME = 'firstName';
  static const String LAST_NAME = 'lastName';
  static const String EMAIL = 'email';
  static const String PHOTO = 'photo';
  static const String GENDER = 'gender';
  static const String AGE_GROUP = 'ageGroup';
  static const String WEIGHT = 'weight';
  static const String HEIGHT = 'height';

  static void setStringData(String key, String val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, val);
  }

  static Future<String> getStringData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  static void setIntData(String key, int val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, val);
  }

  static Future<int> getIntData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  static void setBooleanData(String key, bool val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, val);
  }

  static Future<bool> getBooleanData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static void setListDynamicData(String key, String val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(val));
  }

  static Future<String> getListDynamicData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key));
  }

  static void setUserData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  static Future<String> getUserData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key));
  }

  static Future<bool> removeString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key) ?? false;
  }

  static Future<bool> clearSession() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.clear() ?? false;
  }
}
