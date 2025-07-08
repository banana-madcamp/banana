import 'package:banana/main/models/product.dart';

class Order {
  final String orderId;
  final String userId;
  final Product product;
  final DateTime orderedAt;
  final double orderAmount;
  final double deliveryPrice;
  final double totalAmount;

  Order({
    required this.orderId,
    required this.userId,
    required this.product,
    required this.orderedAt,
    required this.orderAmount,
    required this.deliveryPrice,
    required this.totalAmount,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'] as String,
      userId: json['userId'] as String,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      orderedAt: DateTime.parse(json['orderedAt'] as String),
      orderAmount: (json['orderAmount'] as num).toDouble(),
      deliveryPrice: (json['deliveryPrice'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }

  toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'product': product.toJson(),
      'orderedAt': orderedAt.toIso8601String(),
      'orderAmount': orderAmount,
      'deliveryPrice': deliveryPrice,
      'totalAmount': totalAmount,
    };
  }
}