import 'package:bankitos_flutter/Screens/MainPage/LogIn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:bankitos_flutter/Services/SocketService.dart';

void main() {
  // Instancia y conecta el socket
  SocketService socketService = SocketService();
  socketService.connectSocket();

  // Corre la aplicación
  runApp(const MyApp());
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
