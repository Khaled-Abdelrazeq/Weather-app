import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesTest {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  final String _kNotificationsPrefs = "allowNotifications";
  final String _kSortingOrderPrefs = "sortOrder";
  SharedPreferences prefs ;

  SharedPreferencesTest(){
    initialPref();
  }

  initialPref()async{
    prefs = await SharedPreferences.getInstance();
  }

  /// ------------------------------------------------------------
  /// Method that returns the user decision to allow notifications
  /// ------------------------------------------------------------
  Future<bool> getAllowsNotifications() async {

    return prefs.getBool(_kNotificationsPrefs) ?? false;
  }

  /// ----------------------------------------------------------
  /// Method that saves the user decision to allow notifications
  /// ----------------------------------------------------------
  Future<bool> setAllowsNotifications(bool value) async {

    return prefs.setBool(_kNotificationsPrefs, value);
  }

  /// ------------------------------------------------------------
  /// Method that returns the user decision on sorting order
  /// ------------------------------------------------------------
  Future<String> getSortingOrder(String key) async {
    String data;
    try {
      data = prefs.getString(key) ?? "Error";
    }catch(e){
      print("Error2: $e");
    }
    return data;
  }

  Future<int> getInt(String key) async {
    return prefs.getInt(key);
  }

  Future<double> getDouble(String key) async {


    return prefs.getDouble(key);
  }

  Future<bool> setSortingOrder(String key, String value) async {

    return prefs.setString(key, value);
  }
  Future<bool> setInt(String key, int value) async {

    return prefs.setInt(key, value);
  }
  Future<bool> setDouble(String key, double value) async {

    return prefs.setDouble(key, value);
  }
}
