class NetStatModel {
  final String interface;
  final int rxSpeed;
  final int txSpeed;

  NetStatModel({
    required this.interface,
    required this.rxSpeed,
    required this.txSpeed,
  });

  // initialize model empty
  factory NetStatModel.empty() {
    return NetStatModel(
      interface: '',
      rxSpeed: 0,
      txSpeed: 0,
    );
  }

  factory NetStatModel.fromJson(Map<String, dynamic> json) {
    return NetStatModel(
      interface: json['interface'],
      rxSpeed: json['rxSpeed'],
      txSpeed: json['txSpeed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'interface': interface,
      'rxSpeed': rxSpeed,
      'txSpeed': txSpeed,
    };
  }
}
