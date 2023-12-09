class CPUInfoModel {
  final int cpuCount;
  final String vendorId;
  final String family;
  final String model;
  final String stepping;
  final String physicalId;
  final String coreId;
  final int cores;
  final String modelName;
  final double mhz;
  final double cacheSize;
  final List<String> flags;
  final String microcode;

  CPUInfoModel({
    required this.cpuCount,
    required this.vendorId,
    required this.family,
    required this.model,
    required this.stepping,
    required this.physicalId,
    required this.coreId,
    required this.cores,
    required this.modelName,
    required this.mhz,
    required this.cacheSize,
    required this.flags,
    required this.microcode,
  });

  factory CPUInfoModel.fromJson(Map<String, dynamic> json) {
    return CPUInfoModel(
      cpuCount: json['cpu_count'],
      vendorId: json['vendor_id'],
      family: json['family'],
      model: json['model'],
      stepping: json['stepping'],
      physicalId: json['physical_id'],
      coreId: json['core_id'],
      cores: json['cores'],
      modelName: json['model_name'],
      mhz: json['mhz'],
      cacheSize: json['cache_size'],
      flags: json['flags'].cast<String>(),
      microcode: json['microcode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpu_count': cpuCount,
      'vendor_id': vendorId,
      'family': family,
      'model': model,
      'stepping': stepping,
      'physical_id': physicalId,
      'core_id': coreId,
      'cores': cores,
      'model_name': modelName,
      'mhz': mhz,
      'cache_size': cacheSize,
      'flags': flags,
      'microcode': microcode,
    };
  }
}
