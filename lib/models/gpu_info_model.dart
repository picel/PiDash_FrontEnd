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
      productName: json['product_name'],
      driverVersion: json['driver_version'],
      totalMemory: json['total_memory'],
      clock: GPUClockModel.fromJson(json['clock']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'driver_version': driverVersion,
      'total_memory': totalMemory,
      'clock': clock.toJson(),
    };
  }
}
