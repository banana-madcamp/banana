import 'package:banana/login/datas/source/user_database_source.dart';
import 'package:banana/login/models/user.dart';
import 'package:banana/login/models/order.dart';
import 'package:banana/main/models/product.dart';

class UserDatabaseSourceDummy extends UserDatabaseSource{
  final List<User> _users = [
    User(
      userId: 'u001', 
      email: 'demo@banana.com', 
      password: '12345', 
      nickname: '바나나',
      address: '대전 유성구 대학로 291',
      location: '대전 유성구',
      profileImageUrl: 'https://via.placeholder.com/150',
      orderHistory: [],
      sellingProducts: [],
      paymentMethods: [],
    )
  ];

  @override
  Future<void> addUser(User user) async{
    _users.add(user);
  }

  @override
  Future<void> deleteUser(String userId) async{
    await Future.delayed(const Duration(milliseconds: 300));
    _users.removeWhere((u) => u.userId == userId);
  }

  @override
  Future<User?> findUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _users.where((u) => u.email == email).isNotEmpty
    ? _users.firstWhere((u) => u.email == email)
    : null;
  }
  
  @override
  Future<List<User>> fetchUsers() async{
    await Future.delayed(const Duration(seconds: 2));
    return _users;
  }

  @override
  Future<void> updateUser(User updatedUser) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _users.indexWhere((u) => u.userId == updatedUser.userId);
    if (index != -1) {
      _users[index] = updatedUser;
    }
  }

  @override
  Future<void> addOrder(String userId, Order order) async{
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _users.indexWhere((u) => u.userId == userId);
    if (index != -1) {
      final user = _users[index];
      final updatedUser = user.copyWith(
        orderHistory: [...user.orderHistory, order],
      );
      _users[index] = updatedUser;
    }
  }

  @override
  Future<void> addProduct(String userId, Product product) async{
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _users.indexWhere((u) => u.userId == userId);
    if (index != -1) {
      final user = _users[index];
      final updatedUser = user.copyWith(
        sellingProducts: [...user.sellingProducts, product],
      );
      _users[index] = updatedUser;
    }
  }
}