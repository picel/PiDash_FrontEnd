import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WSService {
  String? baseUrl; // Nullable 타입으로 변경
  String? port; // Nullable 타입으로 변경
  final String prefix = '/ws';

  WebSocketChannel? channel; // Nullable 타입으로 변경
  final String socketUrl;

  WSService(this.socketUrl) {
    initialize(); // 비동기 초기화 시작
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    baseUrl = prefs.getString('ip') ?? '192.168.0.21';
    port = prefs.getString('port') ?? '8080';
    connect(); // 초기화 후 연결
  }

  void connect() {
    if (baseUrl != null && port != null) {
      // Null 체크
      channel = WebSocketChannel.connect(
          Uri.parse('ws://$baseUrl:$port$prefix$socketUrl'));
    }
  }

  Stream<dynamic> get stream =>
      channel?.stream ?? Stream.empty(); // Null 체크 및 fallback 스트림

  void close() {
    channel?.sink.close(); // Null 체크
  }
}
