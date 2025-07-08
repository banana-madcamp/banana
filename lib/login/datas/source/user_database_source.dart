import 'package:banana/login/models/user.dart';
import 'package:banana/login/models/order.dart';
import 'package:banana/main/models/product.dart';

abstract class UserDatabaseSource {
  //fetches all users from the backend
  Future<List<User>> fetchUsers();

  // add user to the backend
  Future<void> addUser(User user);

  // delete user 
  Future<void> deleteUser(String userId);

  Future<void> addOrder(String userId, Order order);

  Future<User?> findUser(String email, String password);

  Future<void> addProduct(String userId, Product product);

  Future<void> updateUser(User updatedUser);

  Future<User> getCurrentUser();
  
  Future<void> logout();
}
