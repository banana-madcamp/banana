abstract class StorageSource {
  /// Fetches the data from the storage.
  Future<void> fetchData();

  /// Saves the data to the storage.
  Future<void> saveData();

  /// Deletes the data from the storage.
  Future<void> deleteData();
}