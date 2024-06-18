import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

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
    });

    // Escucha los mensajes del servidor
    socket.on('new-place-created', (newPlace) {
      print('New place created: $newPlace');
    });
  }
}
