import 'package:bankitos_flutter/Screens/Search.dart';
import 'package:bankitos_flutter/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bankitos_flutter/Widgets/NavBar.dart';
import 'package:bankitos_flutter/Screens/EditProfile.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_core/firebase_core.dart'; // Asegúrate de importar Firebase Core

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // Inicializa Firebase si lo estás utilizando
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: LoginScreen(),
      // home: SearchScreen(),
    );
  }
}
