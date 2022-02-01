import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todolistapp/cache_data/shared_preference_service.dart';
import 'package:todolistapp/globals/global_variables.dart';
import 'package:todolistapp/screens/todo_list_screen.dart';
import 'package:todolistapp/screens/user_login_page.dart';

class AppSplashScreen extends StatefulWidget {
  const AppSplashScreen({Key? key}) : super(key: key);

  @override
  _AppSplashScreenState createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen> {
  late SharedPreferenceService _sharedPreferenceService;

  @override
  void initState() {
    super.initState();
    _sharedPreferenceService = SharedPreferenceService();

    Timer(const Duration(seconds: 5), () {});
    isUserDataAvailable();
  }

  void isUserDataAvailable() async {
    await _sharedPreferenceService.getUserData();

    if (globalEMAIL != null || globalUSERPASSWORD != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ToDoListScreen(
            title: "Todo List",
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
