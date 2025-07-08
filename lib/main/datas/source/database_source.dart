import 'dart:io';

import 'package:banana/main/models/product.dart';

abstract class DatabaseSource {
  /// Fetches the data from the backend.
  Stream<List<Product>> fetchItems();

  /// Saves the data to the backend.
  Future<void> uploadProduct(Product product);

  Future<List<String>> uploadImages(String productId, List<File> images);

  /// Deletes the data from the backend.
  Future<void> deleteProduct(String productId);

  Future<void> editProduct(String productId, Product product);

  Future<void> purchaseProduct(
    String productId,
    String userId,
  );
}
