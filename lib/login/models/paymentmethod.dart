class PaymentMethod {
  final String type;
  final String details;

  PaymentMethod({
    required this.type,
    required this.details,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      type: json['type'] as String,
      details: json['details'] as String,
    );
  }

  toJson() {
    return {
      'type': type,
      'details': details,
    };
  }
}