import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // บันทึกค่า email และ รหัสผ่านไว้ สำหรับ login
  static Future<void> saveUserCredentials(String email, String password) async {
    await _prefs.setString('email', email);
    await _prefs.setString('password', password);
  }
  // get ค่า จาก email
  static String? getEmail() {
    return _prefs.getString('email');
  }
  // get ค่า จาก รหัสผ่าน
  static String? getPassword() {
    return _prefs.getString('password');
  }

  // เคลีย ค่า email และ รหัสผ่าน
  static Future<void> clearUserCredentials() async {
    await _prefs.remove('email');
    await _prefs.remove('password');
  }
}
