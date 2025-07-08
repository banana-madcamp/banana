import 'package:banana/login/models/user.dart';
import 'package:banana/login/models/order.dart';
import 'package:banana/main/models/product.dart';

abstract class UserDatabaseSource {
  //fetches all users from the backend
  Future<List<User>> fetchUsers();

  // add user to the backend
  Future<User?> addUser(String email, String password, String nickname);

  Future<User?> autoLogin();

  // delete user
  Future<void> deleteUser(String userId);

  Future<void> addOrder(String userId, Order order);

  Future<User?> findUser(String email, String password);

  Future<void> updateUser(User updatedUser);

  Future<User> getCurrentUser();

  // 로그아웃 메서드
  Future<void> logout();
}
