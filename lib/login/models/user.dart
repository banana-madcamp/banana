import 'package:banana/login/models/deliverymethod.dart';
import 'package:banana/login/models/order.dart';
import 'package:banana/main/models/product.dart';
import 'package:banana/login/models/paymentmethod.dart';

class User {
  final String userId;
  final String email;
  final String password;
  final String nickname;
  final String address;
  final String location;
  final String profileImageUrl;
  final List<Order> orderHistory;
  final List<Product> sellingProducts;
  final List<PaymentMethod> paymentMethods;
  final List<DeliveryMethod> deliveryMethods;

  User({
  required this.userId,
  required this.email,
  required this.password,
  required this.nickname,
  required this.address,
  required this.location,
  required this.profileImageUrl,
  required this.orderHistory,
  required this.sellingProducts,
  required this.paymentMethods,
  required this.deliveryMethods,
  });
}

extension UserCopy on User {
  User copyWith({
    String? email,
    String? password,
    String? nickname,
    String? profileImageUrl,
    List<Order>? orderHistory,
    List<Product>? sellingProducts,
    String? location,
    String? address,
    List<PaymentMethod>? paymentMethods,
    List<DeliveryMethod>? deliveryMethods,
  }) {
    return User(
      userId: userId,
      email: email ?? this.email,
      password: password ?? this.password,
      nickname: nickname ?? this.nickname,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      orderHistory: orderHistory ?? this.orderHistory,
      sellingProducts: sellingProducts ?? this.sellingProducts,
      location: location ?? this.location,
      address: address ?? this.address,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      deliveryMethods: deliveryMethods ?? this.deliveryMethods,
    );
  }
}

