class Product {
  final String userId;
  final String id;
  final String title;
  final String subTitle;
  final String description;
  final double price;
  final List<String> tag;
  final String location;
  final String thumbnailImageUrl;
  final List<String> imageUrls;
  final DateTime createdAt;

  Product({
    required this.userId,
    required this.id,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.price,
    required this.tag,
    required this.location,
    required this.thumbnailImageUrl,
    required this.imageUrls,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      userId: json['userId'] as String,
      id: json['id'] as String,
      title: json['title'] as String,
      subTitle: json['subTitle'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      tag: List<String>.from(json['tag'] as List<dynamic>),
      location: json['location'] as String,
      thumbnailImageUrl: json['thumbnailImageUrl'] as String,
      imageUrls: List<String>.from(json['imageUrls'] as List<dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'subTitle': subTitle,
      'description': description,
      'price': price,
      'tag': tag,
      'location': location,
      'thumbnailImageUrl': thumbnailImageUrl,
      'imageUrls': imageUrls,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
