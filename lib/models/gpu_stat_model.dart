import 'package:pi_dash/models/gpu_submodels/gpu_clock_model.dart';
import 'package:pi_dash/models/gpu_submodels/gpu_memory_usage_model.dart';
import 'package:pi_dash/models/gpu_submodels/gpu_power.model.dart';
import 'package:pi_dash/models/gpu_submodels/gpu_util_model.dart';

class GPUStatModel {
  final GPUMemoryUsageModel memoryUsage;
  final GPUUtilizationModel utilization;
  final double temperature;
  final GPUPowerModel power;
  final GPUClockModel clock;

  GPUStatModel({
    required this.memoryUsage,
    required this.utilization,
    required this.temperature,
    required this.power,
    required this.clock,
  });

  // initialize model empty
  factory GPUStatModel.empty() {
    return GPUStatModel(
      memoryUsage: GPUMemoryUsageModel.empty(),
      utilization: GPUUtilizationModel.empty(),
      temperature: 0.0,
      power: GPUPowerModel.empty(),
      clock: GPUClockModel.empty(),
    );
  }

  factory GPUStatModel.fromJson(Map<String, dynamic> json) {
    return GPUStatModel(
      memoryUsage: GPUMemoryUsageModel.fromJson(json['memoryUsage']),
      utilization: GPUUtilizationModel.fromJson(json['utilization']),
      temperature: json['temperature'] * 1.0,
      power: GPUPowerModel.fromJson(json['power']),
      clock: GPUClockModel.fromJson(json['clock']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memoryUsage': memoryUsage.toJson(),
      'utilization': utilization.toJson(),
      'temperature': temperature,
      'power': power.toJson(),
      'clock': clock.toJson(),
    };
  }
}
