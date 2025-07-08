import 'package:banana/main/models/product.dart';

abstract class DatabaseSource {
  /// Fetches the data from the backend.
  Future<List<Product>> fetchItems();

  /// Saves the data to the backend.
  Future<void> uploadProduct(Product product);

  Future<List<String>> uploadImages(List<String> imagePaths);

  /// Deletes the data from the backend.
  Future<void> deleteData();
}
