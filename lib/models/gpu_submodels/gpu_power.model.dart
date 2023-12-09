class GPUPowerModel {
  final double usage;
  final double limit;

  GPUPowerModel({
    required this.usage,
    required this.limit,
  });

  // initialize model empty
  factory GPUPowerModel.empty() {
    return GPUPowerModel(
      usage: 0.0,
      limit: 0.0,
    );
  }

  factory GPUPowerModel.fromJson(Map<String, dynamic> json) {
    return GPUPowerModel(
      usage: json['usage'] * 1.0,
      limit: json['limit'] * 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usage': usage,
      'limit': limit,
    };
  }
}
