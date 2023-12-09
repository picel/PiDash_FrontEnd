class MemStatModel {
  final int total;
  final int available;
  final int used;
  final int free;

  MemStatModel({
    required this.total,
    required this.available,
    required this.used,
    required this.free,
  });

  // initialize model empty
  factory MemStatModel.empty() {
    return MemStatModel(
      total: 0,
      available: 0,
      used: 0,
      free: 0,
    );
  }

  factory MemStatModel.fromJson(Map<String, dynamic> json) {
    return MemStatModel(
      total: json['memTotal'],
      available: json['memAvailable'],
      used: json['memUsed'],
      free: json['memFree'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memTotal': total,
      'memAvailable': available,
      'memUsed': used,
      'memFree': free,
    };
  }
}
