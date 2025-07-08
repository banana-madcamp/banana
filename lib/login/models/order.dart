import 'package:banana/main/models/product.dart';

class Order {
  final String orderId;
  final Product product;
  final DateTime orderedAt;

  Order({
    required this.orderId,
    required this.product,
    required this.orderedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'] as String,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      orderedAt: DateTime.parse(json['orderedAt'] as String),
    );
  }

  toJson() {
    return {
      'orderId': orderId,
      'product': product.toJson(),
      'orderedAt': orderedAt.toIso8601String(),
    };
  }
}