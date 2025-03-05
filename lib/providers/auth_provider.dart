import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
Future<bool>register(String username,String password)async{
final db=await DatabaseHelper.instance.database;

final exitsingUser=await db.query('users',
where: 'username = ?',
whereArgs: [username],
);
if (exitsingUser.isNotEmpty){
  return false;
}
await db.insert('users', {
  'username':username,
  'password':password},
  );
  return true;
}



  Future<bool> login(String username, String password) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      _isAuthenticated = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isAuthenticated', true);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isAuthenticated');
    _isAuthenticated = false;
    notifyListeners();
  }
}