class FridgeItemModel {
  final String name;
  final String idealTemp;
  final String expiryNote;

  FridgeItemModel({
    required this.name,
    required this.idealTemp,
    required this.expiryNote,
  });

  factory FridgeItemModel.fromJson(Map<String, dynamic> json) {
    return FridgeItemModel(
      name: json['name'] ?? '',
      idealTemp: json['idealTemp'] ?? '5°C',
      expiryNote: json['expiryNote'] ?? '',
    );
  }
}
