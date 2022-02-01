import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolistapp/globals/global_variables.dart';

class SharedPreferenceService {
  final String _sharedPreferenceUserKey = "username";
  final String _sharedPreferencePwdKey = "password";
  final String _sharedPreferenceEmailKey = "email";
  final String _sharedPreferenceDocIdKey = "userDocId";

  _getInstance() async {
    return SharedPreferences.getInstance();
  }

  Future saveUserData(Map<String, dynamic> map) async {

    SharedPreferences _prefs = await _getInstance();
    _prefs.setString(_sharedPreferenceUserKey, map['username']);
    _prefs.setString(_sharedPreferenceEmailKey, map['email']);
    _prefs.setString(_sharedPreferencePwdKey, map['password']);
    _prefs.setString(_sharedPreferenceDocIdKey, map['userDocId']);

    getUserData();
    
  }

  Future getUserData() async {
    SharedPreferences _prefs = await _getInstance();
    globalUSERNAME = _prefs.getString(_sharedPreferenceUserKey);
    globalEMAIL = _prefs.getString(_sharedPreferenceEmailKey);
    globalUSERPASSWORD = _prefs.getString(_sharedPreferencePwdKey);
    globalUSERDOCID = _prefs.getString(_sharedPreferenceDocIdKey);
  }

  Future removeUserData() async {
    SharedPreferences _prefs = await _getInstance();
    _prefs.remove(_sharedPreferenceUserKey);
    _prefs.remove(_sharedPreferenceEmailKey);
    _prefs.remove(_sharedPreferencePwdKey);
    _prefs.remove(_sharedPreferenceDocIdKey);
    return true;
  }
}
