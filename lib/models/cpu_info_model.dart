class CPUInfoModel {
  final int cpu;
  final String vendorId;
  final String family;
  final int stepping;
  final String physicalId;
  final int cores;
  final String modelName;
  final double clock;
  final int cacheSize;

  CPUInfoModel({
    required this.cpu,
    required this.vendorId,
    required this.family,
    required this.stepping,
    required this.physicalId,
    required this.cores,
    required this.modelName,
    required this.clock,
    required this.cacheSize,
  });

  factory CPUInfoModel.fromJson(Map<String, dynamic> json) {
    return CPUInfoModel(
      cpu: json['cpu'],
      vendorId: json['vendorId'],
      family: json['family'],
      stepping: json['stepping'],
      physicalId: json['physicalId'],
      cores: json['cores'],
      modelName: json['modelName'],
      clock: json['clock'] * 1.0,
      cacheSize: json['cacheSize'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpu': cpu,
      'vendorId': vendorId,
      'family': family,
      'stepping': stepping,
      'physicalId': physicalId,
      'cores': cores,
      'modelName': modelName,
      'clock': clock,
      'cacheSize': cacheSize,
    };
  }
}
