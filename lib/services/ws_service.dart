import 'package:web_socket_channel/web_socket_channel.dart';

class WSService {
  final String baseUrl;

  late WebSocketChannel channel; // Nullable 타입으로 변경

  WSService(this.baseUrl) {
    initialize(); // 비동기 초기화 시작
  }

  Future<void> initialize() async {
    print('Initializing WebSocket');
    print('Connecting to $baseUrl');
    connect(); // 초기화 후 연결
  }

  void connect() {
    channel = WebSocketChannel.connect(Uri.parse('ws://$baseUrl'));
  }

  Stream<dynamic> get stream => channel.stream;

  void close() {
    channel.sink.close(); // Null 체크
  }
}
