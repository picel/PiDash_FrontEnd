import 'package:flutter/material.dart';
import 'package:pi_dash/models/net_info_model.dart';
import 'package:pi_dash/services/api_service.dart';

class NetInfoView extends StatefulWidget {
  const NetInfoView({super.key});

  @override
  State<NetInfoView> createState() => _NetInfoViewState();
}

class _NetInfoViewState extends State<NetInfoView> {
  List<NetInfoModel> netInfo = [];

  fetchNetInfo() async {
    var data = await ApiService().fetchData('/net');
    setState(() {
      for (var i in data) {
        netInfo.add(NetInfoModel.fromJson(i));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchNetInfo();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xff463f3a),
      title: Text(
        'Network Info',
        style: TextStyle(
          color: const Color(0xffbcb8b1),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        // build a list of widgets. Each widget is a row of the table
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: netInfo.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffbcb8b1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // i.keys
                      for (var i in netInfo[index].toJson().keys)
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                i,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025,
                                ),
                              ),
                              Spacer(),
                              Text(
                                netInfo[index].toJson()[i].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Close',
            style: TextStyle(
              color: const Color(0xffbcb8b1),
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
        ),
      ],
    );
  }
}
