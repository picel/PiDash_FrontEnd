import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pi_dash/models/gpu_stat_model.dart';
import 'package:pi_dash/models/mem_stat_model.dart';
import 'package:pi_dash/models/net_stat_model.dart';
import 'package:pi_dash/services/ws_service.dart';
import 'package:wakelock/wakelock.dart';

class RealTimeView extends StatefulWidget {
  const RealTimeView({super.key});

  @override
  State<RealTimeView> createState() => _RealTimeViewState();
}

class _RealTimeViewState extends State<RealTimeView> {
  final WSService _cpuWebScoket = WSService('/cpu');
  final WSService _gpuWebScoket = WSService('/gpu');
  final WSService _memWebScoket = WSService('/mem');
  final WSService _netWebScoket = WSService('/net');

  List cpuData = [];
  double cpuAvg = 0.0;
  bool isAlive = false;

  GPUStatModel gpuData = GPUStatModel.empty();
  MemStatModel memData = MemStatModel.empty();
  NetStatModel netData = NetStatModel.empty();

  showDialogBox() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Connection Lost',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  cpuFetch();
                  gpuFetch();
                  memFetch();
                  netFetch();
                },
                child: Text(
                  'Retry',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  cpuFetch() {
    _cpuWebScoket.connect();
    _cpuWebScoket.stream.listen(
      (event) {
        var data = jsonDecode(event);
        setState(() {
          cpuData = [];
          cpuAvg = 0.0;
          isAlive = true;
          for (var i = 0; i < data.length; i++) {
            cpuData.add(data[i] * 1.0);
            cpuAvg += data[i];
          }
          cpuAvg /= data.length;
        });
      },
      onDone: () {
        setState(() {
          cpuData = [];
          cpuAvg = 0.0;
          isAlive = false;
        });
        showDialogBox();
      },
    );
  }

  gpuFetch() {
    _gpuWebScoket.connect();
    _gpuWebScoket.stream.listen(
      (event) {
        var data = jsonDecode(event);
        setState(() {
          isAlive = true;
          gpuData = GPUStatModel.fromJson(data);
        });
      },
      onDone: () {
        setState(() {
          gpuData = GPUStatModel.empty();
          isAlive = false;
        });
      },
    );
  }

  memFetch() {
    _memWebScoket.connect();
    _memWebScoket.stream.listen(
      (event) {
        var data = jsonDecode(event);
        setState(() {
          isAlive = true;
          memData = MemStatModel.fromJson(data);
        });
      },
      onDone: () {
        setState(() {
          memData = MemStatModel.empty();
          isAlive = false;
        });
      },
    );
  }

  netFetch() {
    _netWebScoket.connect();
    _netWebScoket.stream.listen(
      (event) {
        var data = jsonDecode(event);
        setState(() {
          isAlive = true;
          netData = NetStatModel.fromJson(data);
        });
      },
      onDone: () {
        setState(() {
          netData = NetStatModel.empty();
          isAlive = false;
        });
      },
    );
  }

  byteCountDecimal(byteCount) {
    var bytes = byteCount;
    var unit = 'B';
    if (bytes >= 1024) {
      bytes /= 1024;
      unit = 'KB';
    }
    if (bytes >= 1024) {
      bytes /= 1024;
      unit = 'MB';
    }
    if (bytes >= 1024) {
      bytes /= 1024;
      unit = 'GB';
    }
    if (bytes >= 1024) {
      bytes /= 1024;
      unit = 'TB';
    }
    return '${bytes.toStringAsFixed(2)}$unit';
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();

    cpuFetch();
    gpuFetch();
    memFetch();
    netFetch();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xff5b8e7d),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.025,
                  vertical: MediaQuery.of(context).size.height * 0.005,
                ),
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CPU',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffecf39e),
                          ),
                        ),
                        Text(
                          '${cpuAvg.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffecf39e),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: BarChart(
                        BarChartData(
                          minY: 0,
                          maxY: 100,
                          barTouchData: BarTouchData(
                            enabled: false,
                          ),
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                              show: true,
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    var style = TextStyle(
                                      color: Color(0xffecf39e),
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    );
                                    Widget text;
                                    text = Text(value.toInt().toString(),
                                        style: style);
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      space: 0,
                                      child: text,
                                    );
                                  },
                                ),
                              )),
                          barGroups: [
                            for (int i = 0; i < cpuData.length; i++)
                              BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    width: MediaQuery.of(context).size.width *
                                        0.25 /
                                        cpuData.length,
                                    toY: cpuData[i],
                                    color: Color(0xffecf39e),
                                    backDrawRodData: BackgroundBarChartRodData(
                                      show: true,
                                      toY: 100,
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xffa3b18a),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.025,
                  vertical: MediaQuery.of(context).size.height * 0.02,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GPU',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff344e41),
                      ),
                    ),
                    Text(
                      'Core ${gpuData.utilization.gpu.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff344e41),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.25 / 10,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              width: max(
                                gpuData.utilization.gpu /
                                    100 *
                                    MediaQuery.of(context).size.width *
                                    0.4,
                                MediaQuery.of(context).size.height * 0.25 / 10,
                              ),
                              height: MediaQuery.of(context).size.height *
                                  0.25 /
                                  10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xff344e41),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Memory ${gpuData.utilization.memory.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff344e41),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.25 / 10,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              width: max(
                                gpuData.utilization.memory /
                                    100 *
                                    MediaQuery.of(context).size.width *
                                    0.4,
                                MediaQuery.of(context).size.height * 0.25 / 10,
                              ),
                              height: MediaQuery.of(context).size.height *
                                  0.25 /
                                  10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xff344e41),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Temperature ${gpuData.temperature.toStringAsFixed(2)}°C',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff344e41),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.25 / 10,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              width: max(
                                gpuData.temperature /
                                    100 *
                                    MediaQuery.of(context).size.width *
                                    0.4,
                                MediaQuery.of(context).size.height * 0.25 / 10,
                              ),
                              height: MediaQuery.of(context).size.height *
                                  0.25 /
                                  10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: (gpuData.temperature > 80)
                                    ? Colors.red
                                    : (gpuData.temperature > 50)
                                        ? Colors.yellow
                                        : Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Power ${gpuData.power.usage.toStringAsFixed(2)}W/${gpuData.power.limit.toStringAsFixed(2)}W',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff344e41),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.25 / 10,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              width: (gpuData.power.limit == 0)
                                  ? MediaQuery.of(context).size.height *
                                      0.25 /
                                      10
                                  : max(
                                      gpuData.power.usage /
                                          gpuData.power.limit *
                                          MediaQuery.of(context).size.width *
                                          0.4,
                                      MediaQuery.of(context).size.height *
                                          0.25 /
                                          10,
                                    ),
                              height: MediaQuery.of(context).size.height *
                                  0.25 /
                                  10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    (gpuData.power.usage / gpuData.power.limit >
                                            0.8)
                                        ? Colors.red
                                        : (gpuData.power.usage /
                                                    gpuData.power.limit >
                                                0.5)
                                            ? Colors.yellow
                                            : Color(0xff344e41),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.6),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.025,
                        vertical: MediaQuery.of(context).size.height * 0.01,
                      ),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'SM Clock',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff344e41),
                                ),
                              ),
                              Text(
                                gpuData.clock.smClock,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff344e41),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Memory Clock',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff344e41),
                                ),
                              ),
                              Text(
                                gpuData.clock.memClock,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff344e41),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Video Clock',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff344e41),
                                ),
                              ),
                              Text(
                                gpuData.clock.videoClock,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff344e41),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Graphics Clock',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff344e41),
                                ),
                              ),
                              Text(
                                gpuData.clock.graphicsClock,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff344e41),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xff4a4e69),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.025,
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Memory',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffc9ada7),
                      ),
                    ),
                    Text(
                      '${byteCountDecimal(memData.used)} / ${byteCountDecimal(memData.total)}',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffc9ada7),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.025,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      // show memory usage bar with used, reserved
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          width: (memData.total == 0)
                              ? 0
                              : max(
                                  memData.used /
                                      memData.total *
                                      MediaQuery.of(context).size.width *
                                      0.8,
                                  MediaQuery.of(context).size.height *
                                      0.25 /
                                      10,
                                ),
                          height:
                              MediaQuery.of(context).size.height * 0.25 / 10,
                          decoration: BoxDecoration(
                            color: Color(0xffc9ada7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xff463f3a),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.025,
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // stack row and text, text should be on center
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_upward_outlined,
                              color: Color(0xffbcb8b1),
                              size: MediaQuery.of(context).size.height * 0.04,
                            ),
                            Text(
                              '${byteCountDecimal(netData.txSpeed)}/s',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffbcb8b1),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_downward_outlined,
                              color: Color(0xffbcb8b1),
                              size: MediaQuery.of(context).size.height * 0.04,
                            ),
                            Text(
                              '${byteCountDecimal(netData.rxSpeed)}/s',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffbcb8b1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        (netData.interface == '')
                            ? 'No Traffic'
                            : netData.interface,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffbcb8b1),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
