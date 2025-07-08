import 'dart:io';
import 'dart:math';

import 'package:banana/main/models/product.dart';

import '../source/database_source.dart';

class DatabaseSourceDummy extends DatabaseSource {
  @override
  Future<void> uploadProduct(Product product) {
    return Future.delayed(const Duration(seconds: 5), () {
      return true;
    });
  }

  @override
  Future<void> deleteProduct(String productId) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<void> editProduct(String productId, Product product) {
    // TODO: implement editProduct
    throw UnimplementedError();
  }

  @override
  Future<void> purchaseProduct(String productId, String userId) {
    // TODO: implement purchaseProduct
    throw UnimplementedError();
  }

  @override
  Future<List<String>> uploadImages(String productId, List<File> images) {
    // TODO: implement uploadImages
    throw UnimplementedError();
  }

  @override
  Stream<List<Product>> fetchItems() {
    // TODO: implement fetchItems
    throw UnimplementedError();
  }
}
