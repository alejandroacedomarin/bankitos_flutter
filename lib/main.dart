import 'package:bankitos_flutter/Screens/MainPage/SearchEngine.dart';
import 'package:bankitos_flutter/Screens/MainPage/LogIn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bankitos_flutter/Widgets/NavBar.dart';
import 'package:bankitos_flutter/Screens/Users/UpdateUser.dart';
void main() {
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: LoginScreen(),
      //home: SearchScreen(),
    );
  }
}

