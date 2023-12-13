import 'package:flutter/material.dart';
import 'package:pi_dash/models/cpu_info_model.dart';
import 'package:pi_dash/services/api_service.dart';

class CPUInfoView extends StatefulWidget {
  const CPUInfoView({super.key});

  @override
  State<CPUInfoView> createState() => _CPUInfoViewState();
}

class _CPUInfoViewState extends State<CPUInfoView> {
  List<CPUInfoModel> cpuInfo = [];

  fetchCPUInfo() async {
    var data = await ApiService().fetchData('/cpu');
    setState(() {
      for (var i in data) {
        cpuInfo.add(CPUInfoModel.fromJson(i));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCPUInfo();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xff5b8e7d),
      title: Text(
        'CPU Info',
        style: TextStyle(
          color: const Color(0xffecf39e),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        // build a list of widgets. Each widget is a row of the table
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: cpuInfo.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffecf39e),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // i.keys
                      for (var i in cpuInfo[index].toJson().keys)
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
                                cpuInfo[index].toJson()[i].toString(),
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
              color: const Color(0xffecf39e),
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
        ),
      ],
    );
  }
}
