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
}
