import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pi_dash/views/init_view.dart';
import 'package:pi_dash/views/realtime_view.dart';

void main() {
  runApp(const Main());

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pi Dash',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        colorScheme: ThemeData.light()
            .colorScheme
            .copyWith(background: const Color(0xffFFF7D4)),
      ),
      home: const InitView(),
      routes: {
        '/init': (context) => const InitView(),
        '/realtime': (context) {
          final baseUrl = ModalRoute.of(context)!.settings.arguments as String;
          return RealTimeView(baseUrl: baseUrl);
        }
      },
      initialRoute: '/init',
    );
  }
}
