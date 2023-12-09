class NetInfoModel {
  final String interface;
  final String mac;

  NetInfoModel({
    required this.interface,
    required this.mac,
  });

  factory NetInfoModel.fromJson(Map<String, dynamic> json) {
    return NetInfoModel(
      interface: json['interface'],
      mac: json['mac'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'interface': interface,
      'mac': mac,
    };
  }
}
