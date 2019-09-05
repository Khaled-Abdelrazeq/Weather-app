import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesEx{
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  Future<Null> setData(String key, String value) async{
    SharedPreferences preferences = await _pref;
    preferences.setString(key, value);
  }

  Future<String> getData(String key) async{
    SharedPreferences preferences = await _pref;
    String data = preferences.getString(key);
    return data;
  }

}