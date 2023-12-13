class MemInfoModel {
  final int total;

  MemInfoModel({
    required this.total,
  });

  factory MemInfoModel.fromJson(Map<String, dynamic> json) {
    return MemInfoModel(
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
    };
  }
}
