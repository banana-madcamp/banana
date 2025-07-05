import 'package:banana/main/models/product.dart';

abstract class DatabaseSource {
  /// Fetches the data from the backend.
  Future<List<Product>> fetchData();

  /// Saves the data to the backend.
  Future<void> saveData();

  /// Deletes the data from the backend.
  Future<void> deleteData();
}