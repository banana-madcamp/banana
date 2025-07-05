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
  Future<void> saveData() {
    // TODO: implement saveData
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> fetchData() {
    return Future.delayed(
      const Duration(seconds: 5),
          () {
        return [
          for (int i = 0; i < 10; i++)
            Product(
              id: "$i",
              title: 'Banana Chips - lorem ipsum dolor sit amet, consectetur',
              description: 'This is a dummy product description.',
              price: pow(10, i).toDouble(),
              imageUrl: 'https://via.placeholder.com/150',
              userId: '',
              subTitle: 'this is a dummy product sub title',
              tag: ['dummy'],
              location: '대전 유성구',
              createdAt: DateTime.now()
            ),
        ];
      },
    );
  }
}
