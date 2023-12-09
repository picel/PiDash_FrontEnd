class GPUMemoryUsageModel {
  final double total;
  final double reserved;
  final double used;
  final double free;

  GPUMemoryUsageModel({
    required this.total,
    required this.reserved,
    required this.used,
    required this.free,
  });

  // initialize model empty
  factory GPUMemoryUsageModel.empty() {
    return GPUMemoryUsageModel(
      total: 0.0,
      reserved: 0.0,
      used: 0.0,
      free: 0.0,
    );
  }

  factory GPUMemoryUsageModel.fromJson(Map<String, dynamic> json) {
    return GPUMemoryUsageModel(
      total: json['total'] * 1.0,
      reserved: json['reserved'] * 1.0,
      used: json['used'] * 1.0,
      free: json['free'] * 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'reserved': reserved,
      'used': used,
      'free': free,
    };
  }
}
