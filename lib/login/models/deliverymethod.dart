class DeliveryMethod {
  final String type;
  final String description;
  final String timeFrame;
  final double price;

  DeliveryMethod({
    required this.type,
    required this.description,
    required this.timeFrame,
    required this.price,
  });

  factory DeliveryMethod.fromJson(Map<String, dynamic> json) {
    return DeliveryMethod(
      type: json['type'] as String,
      description: json['description'] as String,
      timeFrame: json['timeFrame'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'description': description,
      'timeFrame': timeFrame,
      'price': price,
    };
  }
}