import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  Future<bool> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return await pref.remove('token');
  }

  Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.getString('token') ?? "";
  }

  Future<int> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.getInt('userId') ?? 0;
  }
}
