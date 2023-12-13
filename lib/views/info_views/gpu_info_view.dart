import 'package:flutter/material.dart';
import 'package:pi_dash/models/gpu_info_model.dart';
import 'package:pi_dash/services/api_service.dart';

class GPUInfoView extends StatefulWidget {
  const GPUInfoView({super.key});

  @override
  State<GPUInfoView> createState() => _GPUInfoViewState();
}

class _GPUInfoViewState extends State<GPUInfoView> {
  List<GPUInfoModel> gpuInfo = [];

  fetchGPUInfo() async {
    var data = await ApiService().fetchData('/gpu');
    setState(() {
      for (var i in data) {
        gpuInfo.add(GPUInfoModel.fromJson(i));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchGPUInfo();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xffa3b18a),
      title: Text(
        'GPU Info',
        style: TextStyle(
          color: const Color(0xff344e41),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        // build a list of widgets. Each widget is a row of the table
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: gpuInfo.length,
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
                      for (var i in gpuInfo[index].toJson().keys)
                        (i == 'maxClock')
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      i,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.025,
                                      ),
                                    ),
                                    for (var j
                                        in gpuInfo[index].toJson()[i].keys)
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              j,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              gpuInfo[index]
                                                  .toJson()[i][j]
                                                  .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      i,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.025,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      gpuInfo[index].toJson()[i].toString(),
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
              color: const Color(0xff344e41),
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
        ),
      ],
    );
  }
}
