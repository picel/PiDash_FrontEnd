class GPUClockModel {
  final String graphicsClock;
  final String smClock;
  final String memClock;
  final String videoClock;

  GPUClockModel({
    required this.graphicsClock,
    required this.smClock,
    required this.memClock,
    required this.videoClock,
  });

  // initialize model empty
  factory GPUClockModel.empty() {
    return GPUClockModel(
      graphicsClock: '',
      smClock: '',
      memClock: '',
      videoClock: '',
    );
  }

  factory GPUClockModel.fromJson(Map<String, dynamic> json) {
    return GPUClockModel(
      graphicsClock: json['graphicsClock'],
      smClock: json['smClock'],
      memClock: json['memClock'],
      videoClock: json['videoClock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'graphicsClock': graphicsClock,
      'smClock': smClock,
      'memClock': memClock,
      'videoClock': videoClock,
    };
  }
}
