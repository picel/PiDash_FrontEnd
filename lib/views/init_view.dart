import 'package:flutter/material.dart';
import 'package:pi_dash/viewmodels/init_viewmodel.dart';

class InitView extends StatefulWidget {
  const InitView({super.key});

  @override
  State<InitView> createState() => _InitViewState();
}

class _InitViewState extends State<InitView> {
  final viewModel = InitViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.fetchSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("PiDash", style: TextStyle(fontSize: 50)),
          const Text(
              "Welcome to Pi Dash!\nyou can easily monitor your Desktop with this app!"),
          SizedBox(
            width: MediaQuery.of(context).orientation == Orientation.landscape
                ? MediaQuery.of(context).size.width * 0.5
                : MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                TextField(
                  controller: viewModel.ipController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'IP Address',
                    hintText: '192.168.0.1',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: viewModel.portController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Port',
                    hintText: '8080',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (await viewModel.checkConnection()) {
                      await viewModel.setSharedPrefs();
                      Navigator.pushNamed(context, '/realtime',
                          arguments:
                              '${viewModel.ipController.text}:${viewModel.portController.text}');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'Connection failed, please check your IP and Port')));
                    }
                  },
                  child: const Text('Connect'),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
