import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pi_dash/utils/FormatUtils.dart';
import 'package:pi_dash/viewmodels/realtime_viewmodel.dart';
import 'package:pi_dash/views/stat_views/cpu_stat_view.dart';
import 'package:pi_dash/views/stat_views/gpu_stat_view.dart';
import 'package:pi_dash/views/stat_views/mem_stat_view.dart';
import 'package:pi_dash/views/stat_views/net_stat_view.dart';
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
              CPUStatView(cpuAvg: viewModel.cpuAvg, cpuData: viewModel.cpuData),
              GPUStatView(gpuData: viewModel.gpuData),
            ],
          ),
          MemStatView(memData: viewModel.memData),
          NetStatView(netData: viewModel.netData),
        ],
      ),
    );
  }
}
