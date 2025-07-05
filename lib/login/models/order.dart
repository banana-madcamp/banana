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
}