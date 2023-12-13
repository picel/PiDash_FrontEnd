import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pi_dash/utils/FormatUtils.dart';
import 'package:pi_dash/viewmodels/realtime_viewmodel.dart';
import 'package:wakelock/wakelock.dart';

class RealTimeView extends StatefulWidget {
  final String baseUrl;

  const RealTimeView({Key? key, required this.baseUrl}) : super(key: key);

  @override
  State<RealTimeView> createState() => _RealTimeViewState();
}

class _RealTimeViewState extends State<RealTimeView> {
  late RealTimeViewModel viewModel;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();

    viewModel = RealTimeViewModel(
      onUpdate: () {
        setState(() {});
      },
      onStreamError: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connection closed'),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.of(context).pushReplacementNamed('/init');
      },
    );
    viewModel.init(widget.baseUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xff5b8e7d),
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
                            color: const Color(0xffecf39e),
                          ),
                        ),
                        Text(
                          '${viewModel.cpuAvg.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xffecf39e),
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
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                              show: true,
                              leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    var style = TextStyle(
                                      color: const Color(0xffecf39e),
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
                            for (int i = 0; i < viewModel.cpuData.cpuCount; i++)
                              BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    width: MediaQuery.of(context).size.width *
                                        0.25 /
                                        viewModel.cpuData.cpuCount,
                                    toY: viewModel.cpuData.loads[i] * 1.0,
                                    color: const Color(0xffecf39e),
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
                  color: const Color(0xffa3b18a),
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
                        color: const Color(0xff344e41),
                      ),
                    ),
                    Text(
                      'Core ${viewModel.gpuData.utilization.gpu.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff344e41),
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
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              width: max(
                                viewModel.gpuData.utilization.gpu /
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
                                color: const Color(0xff344e41),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Memory ${viewModel.gpuData.utilization.memory.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff344e41),
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
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              width: max(
                                viewModel.gpuData.utilization.memory /
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
                                color: const Color(0xff344e41),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Temperature ${viewModel.gpuData.temperature.toStringAsFixed(2)}°C',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff344e41),
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
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              width: max(
                                viewModel.gpuData.temperature /
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
                                color: (viewModel.gpuData.temperature > 80)
                                    ? Colors.red
                                    : (viewModel.gpuData.temperature > 50)
                                        ? Colors.yellow
                                        : Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Power ${viewModel.gpuData.power.usage.toStringAsFixed(2)}W/${viewModel.gpuData.power.limit.toStringAsFixed(2)}W',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff344e41),
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
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              width: (viewModel.gpuData.power.limit == 0)
                                  ? MediaQuery.of(context).size.height *
                                      0.25 /
                                      10
                                  : max(
                                      viewModel.gpuData.power.usage /
                                          viewModel.gpuData.power.limit *
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
                                color: (viewModel.gpuData.power.usage /
                                            viewModel.gpuData.power.limit >
                                        0.8)
                                    ? Colors.red
                                    : (viewModel.gpuData.power.usage /
                                                viewModel.gpuData.power.limit >
                                            0.5)
                                        ? Colors.yellow
                                        : const Color(0xff344e41),
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
                                  color: const Color(0xff344e41),
                                ),
                              ),
                              Text(
                                viewModel.gpuData.clock.smClock,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff344e41),
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
                                  color: const Color(0xff344e41),
                                ),
                              ),
                              Text(
                                viewModel.gpuData.clock.memClock,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff344e41),
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
                                  color: const Color(0xff344e41),
                                ),
                              ),
                              Text(
                                viewModel.gpuData.clock.videoClock,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff344e41),
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
                                  color: const Color(0xff344e41),
                                ),
                              ),
                              Text(
                                viewModel.gpuData.clock.graphicsClock,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff344e41),
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
              color: const Color(0xff4a4e69),
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
                        color: const Color(0xffc9ada7),
                      ),
                    ),
                    Text(
                      '${FormatUtils.byteCountDecimal(viewModel.memData.used)} / ${FormatUtils.byteCountDecimal(viewModel.memData.total)}',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.04,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffc9ada7),
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
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          width: (viewModel.memData.total == 0)
                              ? 0
                              : max(
                                  viewModel.memData.used /
                                      viewModel.memData.total *
                                      MediaQuery.of(context).size.width *
                                      0.8,
                                  MediaQuery.of(context).size.height *
                                      0.25 /
                                      10,
                                ),
                          height:
                              MediaQuery.of(context).size.height * 0.25 / 10,
                          decoration: BoxDecoration(
                            color: const Color(0xffc9ada7),
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
              color: const Color(0xff463f3a),
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
                              color: const Color(0xffbcb8b1),
                              size: MediaQuery.of(context).size.height * 0.04,
                            ),
                            Text(
                              '${FormatUtils.byteCountDecimal(viewModel.netData.txSpeed)}/s',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.04,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xffbcb8b1),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_downward_outlined,
                              color: const Color(0xffbcb8b1),
                              size: MediaQuery.of(context).size.height * 0.04,
                            ),
                            Text(
                              '${FormatUtils.byteCountDecimal(viewModel.netData.rxSpeed)}/s',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.04,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xffbcb8b1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        (viewModel.netData.interface == '')
                            ? 'No Traffic'
                            : viewModel.netData.interface,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.04,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffbcb8b1),
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
