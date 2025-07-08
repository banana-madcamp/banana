import 'package:banana/login/models/user.dart';
import 'package:banana/login/models/order.dart';

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

  Future<void> changePassword(String newPassword);

  Future<void> updateUserLocation(String userId, String location);

  Future<User?> getUserById(String userId);

  Future<void> updateUserNickName(String userId, String nickname);
  // 로그아웃 메서드
  Future<void> logout();
}
