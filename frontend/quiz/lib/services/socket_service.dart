import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  static Socket connect(String quizId, String userId) {
    Socket socket = io('https://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
    socket.onConnect((_) {
      if (kDebugMode) {
        print('Connected');
      }
      socket.emit('joinQuiz', {'quizId': quizId, 'userId': userId});
    });

    socket.onDisconnect((_) {
      if (kDebugMode) {
        print('Disconnected');
      }
    });

    return socket;
  }
}
