import 'package:banana/login/models/deliverymethod.dart';
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
  final List<DeliveryMethod> deliveryMethods;
  final List<String> likedProductIds;

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
  required this.deliveryMethods,
  this.likedProductIds = const []
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
      deliveryMethods: (json['deliveryMethods'] as List<dynamic>)
          .map((e) => DeliveryMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
      likedProductIds: (json['likedProductIds'] as List<dynamic>? ?? [])
          .cast<String>()
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
      'deliveryMethods': deliveryMethods.map((e) => e.toJson()).toList(),
      'likedProductIds': likedProductIds,
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
    List<DeliveryMethod>? deliveryMethods,
    List<String>? likedProductIds,
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
      deliveryMethods: deliveryMethods ?? this.deliveryMethods,
      likedProductIds: likedProductIds ?? this.likedProductIds
    );
  }
}

