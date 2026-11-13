class ProductModel {
  final String name;
  final String tag;
  final String subtitle;
  final double price;

  ProductModel({
    required this.name,
    required this.tag,
    this.subtitle = '',
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] ?? '',
      tag: json['tag'] ?? '',
      subtitle: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
