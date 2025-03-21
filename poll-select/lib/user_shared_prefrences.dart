import 'package:shared_preferences/shared_preferences.dart';

class Usersharedpreferences {
  static SharedPreferences? mypre;

  // Initialize SharedPreferences
  static Future<void> init() async {
    mypre = await SharedPreferences.getInstance();
  }

  // Set and Get methods for preferences
  static Future<void> setFirstTime(bool status) async {
    await mypre!.setBool("firsttime", status);
  }

  static bool? getFirstTime() {
    return mypre!.getBool("firsttime");
  }

  static Future<void> setSignedup(bool status) async {
    await mypre!.setBool("signup", status);
  }

  static bool? getSignedup() {
    return mypre!.getBool("signup");
  }

  static Future<void> setLogin(bool status) async {
    await mypre!.setBool("login", status);
  }

  static bool? getLogin() {
    return mypre!.getBool("login");
  }

  static Future<void> setUserName(String userName) async {
    await mypre!.setString("userName", userName);
  }

  static String? getUserName() {
    return mypre!.getString("userName");
  }

  static Future<void> setUserEmail(String email) async {
    await mypre!.setString("email", email);
  }

  static String? getUserEmail() {
    return mypre!.getString("email");
  }

  static Future<void> setUserPic(String image) async {
    await mypre!.setString("image", image);
  }

  static String? getUserPic() {
    return mypre!.getString("image");
  }

  static Future<void> setUserID(String id) async {
    await mypre!.setString("id", id);
  }

  static String? getUserID() {
    return mypre!.getString("id");
  }

  static Future<void> setSelectedIndex(int index) async {
    await mypre!.setInt("selectedIndex", index);
  }

  static int getSelectedIndex() {
    return mypre!.getInt("selectedIndex") ?? 0; // Return 0 if not found
  }
}
