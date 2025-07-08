import 'dart:math';

import 'package:banana/main/models/product.dart';

import '../source/database_source.dart';

class DatabaseSourceDummy extends DatabaseSource {
  @override
  Future<void> deleteData() {
    // TODO: implement deleteData
    throw UnimplementedError();
  }

  @override
  Future<void> uploadProduct(Product product) {
    return Future.delayed(const Duration(seconds: 5), () {
      return true;
    });
  }

  @override
  Future<List<Product>> fetchItems() {
    return Future.delayed(const Duration(seconds: 5), () {
      return [
        for (int i = 0; i < 10; i++)
          Product(
            id: "$i",
            title: 'Banana Chips - lorem ipsum dolor sit amet, consectetur',
            description: 'This is a dummy product description.',
            price: pow(10, i).toDouble(),
            thumbnailImageUrl: 'https://via.placeholder.com/150',
            userId: '',
            subTitle: 'this is a dummy product sub title',
            tag: ['dummy'],
            location: '대전 유성구',
            createdAt: DateTime.now(),
            imageUrls: ['https://via.placeholder.com/150'],
          ),
      ];
    });
  }

  @override
  Future<List<String>> uploadImages(List<String> imagePaths) {
    return Future.delayed(const Duration(seconds: 5), () {
      return imagePaths
          .map((path) => 'https://via.placeholder.com/150')
          .toList();
    });
  }
}
