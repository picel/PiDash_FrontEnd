import 'package:web_socket_channel/web_socket_channel.dart';

class WSService {
  final String baseUrl = '192.168.0.61';
  final int port = 8080;
  final String prefix = '/ws';

  late WebSocketChannel channel;
  final String socketUrl;

  WSService(this.socketUrl) {
    connect();
  }

  void connect() {
    channel = WebSocketChannel.connect(
        Uri.parse('ws://$baseUrl:$port$prefix$socketUrl'));
  }

  Stream<dynamic> get stream => channel.stream;

  void close() {
    channel.sink.close();
  }
}
