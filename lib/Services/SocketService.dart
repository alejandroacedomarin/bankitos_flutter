import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SocketService extends GetxController {
  late IO.Socket socket;
 final Rx<Function?> _newPlaceCallback = Rx<Function?>(null);
  void connectSocket() {
    // Configura la conexión al socket
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // Conéctate al socket
    socket.connect();

    // Escucha cuando el socket se conecta
    socket.on('user-logged-in', (_) {
      print('Usuario conectado');
      showSnackbar('Usuario conectado');
    });

    // Escucha los mensajes del servidor
    socket.on('new-place-created', (newPlace) {
      print('New place created: $newPlace');
      showSnackbar('Nuevo lugar creado: $newPlace');
      _newPlaceCallback.value?.call(newPlace);
    });
  }

  void showSnackbar(String message) {
    Get.snackbar(
      'Bankitos App',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange,
      colorText: Colors.black,
      icon: Padding(
        padding: EdgeInsets.only(left: 12.0),
        child: Image.asset(
          'assets/logo.png',
          width: 24.0,
          height: 24.0,
          color: Colors.white, // Color de la imagen si es necesario
        ),
      ),
    );
  }
  void setNewPlaceCallback(Function callback) {
    _newPlaceCallback.value = callback;
  }
}
