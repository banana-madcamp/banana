import 'package:banana/login/models/order.dart';
import 'package:banana/main/models/product.dart';
import 'package:banana/login/models/paymentmethod.dart';

class User {
  final String userId;
  final String email;
  final String nickname;
  final String address;
  final String location;
  final String profileImageUrl;
  final List<Order> orderHistory;
  final List<Product> sellingProducts;
  final List<PaymentMethod> paymentMethods;

  User({
  required this.userId,
  required this.email,
  required this.nickname,
  required this.address,
  required this.location,
  required this.profileImageUrl,
  required this.orderHistory,
  required this.sellingProducts,
  required this.paymentMethods,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      address: json['address'] as String,
      location: json['location'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      orderHistory: (json['orderHistory'] as List<dynamic>)
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList(),
      sellingProducts: (json['sellingProducts'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentMethods: (json['paymentMethods'] as List<dynamic>)
          .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  toJson() {
    return {
      'userId': userId,
      'email': email,
      'nickname': nickname,
      'address': address,
      'location': location,
      'profileImageUrl': profileImageUrl,
      'orderHistory': orderHistory.map((e) => e.toJson()).toList(),
      'sellingProducts': sellingProducts.map((e) => e.toJson()).toList(),
      'paymentMethods': paymentMethods.map((e) => e.toJson()).toList(),
    };
  }
}

extension UserCopy on User {
  User copyWith({
    String? email,
    String? nickname,
    String? profileImageUrl,
    List<Order>? orderHistory,
    List<Product>? sellingProducts,
    String? location,
    String? address,
    List<PaymentMethod>? paymentMethods,
  }) {
    return User(
      userId: userId,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      orderHistory: orderHistory ?? this.orderHistory,
      sellingProducts: sellingProducts ?? this.sellingProducts,
      location: location ?? this.location,
      address: address ?? this.address,
      paymentMethods: paymentMethods ?? this.paymentMethods,
    );
  }
}

