import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InitView extends StatefulWidget {
  const InitView({super.key});

  @override
  State<InitView> createState() => _InitViewState();
}

class _InitViewState extends State<InitView> {
  TextEditingController ipController = TextEditingController();
  TextEditingController portController = TextEditingController();

  fetchSharedPrefs() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      ipController.text = prefs.getString('ip') ?? '';
      portController.text = prefs.getString('port') ?? '';
    });
  }

  setSharedPrefs() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('ip', ipController.text);
    prefs.setString('port', portController.text);
  }

  @override
  void initState() {
    super.initState();
    fetchSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("PiDash", style: TextStyle(fontSize: 50)),
          Text(
              "Welcome to Pi Dash!\nyou can easily monitor your Desktop with this app!"),
          Container(
            // if device is in landscape mode, the width is 50% of the screen, else 90%
            width: MediaQuery.of(context).orientation == Orientation.landscape
                ? MediaQuery.of(context).size.width * 0.5
                : MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                TextField(
                  controller: ipController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'IP Address',
                    hintText: '192.168.0.1',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: portController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Port',
                    hintText: '8080',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    // check ip and port accessable with http://ip:port/api/cpu
                    var url = Uri.http(
                        ipController.text + ':' + portController.text,
                        '/api/cpu');
                    var response = await http.get(url);
                    if (response.statusCode != 200) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text(
                                'Cannot connect to the server.\nPlease check your IP and Port.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }

                    setSharedPrefs().then((value) {
                      Navigator.pushNamed(context, '/realtime');
                    });
                  },
                  child: const Text('Connect'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
