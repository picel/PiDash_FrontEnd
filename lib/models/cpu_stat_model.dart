class CPUStatModel {
  final int cpuCount;
  final List loads;

  CPUStatModel({
    required this.cpuCount,
    required this.loads,
  });

  // initialize model empty
  factory CPUStatModel.empty() {
    return CPUStatModel(
      cpuCount: 0,
      loads: [],
    );
  }

  factory CPUStatModel.fromJson(Map<String, dynamic> json) {
    return CPUStatModel(
      cpuCount: json['cpuCount'],
      loads: json['loads'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpuCount': cpuCount,
      'loads': loads,
    };
  }
}
