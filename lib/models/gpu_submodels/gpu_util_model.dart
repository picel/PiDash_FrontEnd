class GPUUtilizationModel {
  final double gpu;
  final double memory;

  GPUUtilizationModel({
    required this.gpu,
    required this.memory,
  });

  // initialize model empty
  factory GPUUtilizationModel.empty() {
    return GPUUtilizationModel(
      gpu: 0.0,
      memory: 0.0,
    );
  }

  factory GPUUtilizationModel.fromJson(Map<String, dynamic> json) {
    return GPUUtilizationModel(
      gpu: json['gpu'] * 1.0,
      memory: json['memory'] * 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gpu': gpu,
      'memory': memory,
    };
  }
}
