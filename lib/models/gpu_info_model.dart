import 'package:pi_dash/models/gpu_submodels/gpu_clock_model.dart';

class GPUInfoModel {
  final String productName;
  final String driverVersion;
  final double totalMemory;
  final GPUClockModel clock;

  GPUInfoModel({
    required this.productName,
    required this.driverVersion,
    required this.totalMemory,
    required this.clock,
  });

  factory GPUInfoModel.fromJson(Map<String, dynamic> json) {
    return GPUInfoModel(
      productName: json['productName'],
      driverVersion: json['driverVersion'],
      totalMemory: json['totalMemory'] * 1.0,
      clock: GPUClockModel.fromJson(json['maxClock']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'driverVersion': driverVersion,
      'totalMemory': totalMemory,
      'maxClock': clock.toJson(),
    };
  }
}
