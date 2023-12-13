import 'dart:convert';

import 'package:pi_dash/models/cpu_stat_model.dart';
import 'package:pi_dash/models/gpu_stat_model.dart';
import 'package:pi_dash/models/mem_stat_model.dart';
import 'package:pi_dash/models/net_stat_model.dart';
import 'package:pi_dash/services/ws_service.dart';

class RealTimeViewModel {
  late final WSService _cpuWebSocket;
  late final WSService _gpuWebSocket;
  late final WSService _memWebSocket;
  late final WSService _netWebSocket;

  double cpuAvg = 0.0;
  bool isAlive = false;

  CPUStatModel cpuData = CPUStatModel.empty();
  GPUStatModel gpuData = GPUStatModel.empty();
  MemStatModel memData = MemStatModel.empty();
  NetStatModel netData = NetStatModel.empty();

  Function()? onUpdate;
  Function()? onStreamError;

  RealTimeViewModel({this.onUpdate, this.onStreamError});

  void cpuFetch() {
    _cpuWebSocket.stream.listen(
      (event) {
        _processCPUData(event);
        onUpdate?.call();
      },
      onError: (error) {
        onStreamError?.call();
      },
      onDone: () {
        _handleStreamClosed();
        onStreamError?.call();
      },
    );
  }

  void gpuFetch() {
    _gpuWebSocket.stream.listen(
      (event) {
        _processGPUData(event);
        onUpdate?.call();
      },
    );
  }

  void memFetch() {
    _memWebSocket.stream.listen(
      (event) {
        _processMemData(event);
        onUpdate?.call();
      },
    );
  }

  void netFetch() {
    _netWebSocket.stream.listen(
      (event) {
        _processNetData(event);
        onUpdate?.call();
      },
    );
  }

  void _processCPUData(dynamic event) {
    cpuData = CPUStatModel.fromJson(jsonDecode(event));
    cpuAvg = cpuData.loads.reduce((a, b) => a + b) / cpuData.loads.length;
  }

  void _processGPUData(dynamic event) {
    gpuData = GPUStatModel.fromJson(jsonDecode(event));
  }

  void _processMemData(dynamic event) {
    memData = MemStatModel.fromJson(jsonDecode(event));
  }

  void _processNetData(dynamic event) {
    netData = NetStatModel.fromJson(jsonDecode(event));
  }

  void _handleStreamClosed() {
    isAlive = false;
    onUpdate?.call();
  }

  void init(String baseUrl) {
    _cpuWebSocket = WSService('$baseUrl/ws/cpu');
    _gpuWebSocket = WSService('$baseUrl/ws/gpu');
    _memWebSocket = WSService('$baseUrl/ws/mem');
    _netWebSocket = WSService('$baseUrl/ws/net');

    isAlive = true;
    cpuFetch();
    gpuFetch();
    memFetch();
    netFetch();
  }
}
