import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pi_dash/utils/FormatUtils.dart';
import 'package:pi_dash/viewmodels/realtime_viewmodel.dart';
import 'package:pi_dash/views/info_views/cpu_info_view.dart';
import 'package:pi_dash/views/info_views/gpu_info_view.dart';
import 'package:pi_dash/views/info_views/net_info_view.dart';
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

  showPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Connection closed'),
          content: Text('Connection to server closed'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
              RawMaterialButton(
                onPressed: () {
                  showDialog(context: context, builder: (_) => CPUInfoView());
                },
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                child: CPUStatView(
                    cpuAvg: viewModel.cpuAvg, cpuData: viewModel.cpuData),
              ),
              RawMaterialButton(
                onPressed: () {
                  showDialog(context: context, builder: (_) => GPUInfoView());
                },
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                child: GPUStatView(gpuData: viewModel.gpuData),
              ),
            ],
          ),
          MemStatView(memData: viewModel.memData),
          RawMaterialButton(
            onPressed: () {
              showDialog(context: context, builder: (_) => NetInfoView());
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            child: NetStatView(netData: viewModel.netData),
          ),
        ],
      ),
    );
  }
}
