import 'package:banana/login/datas/source/user_database_source.dart';
import 'package:banana/login/models/deliverymethod.dart';
import 'package:banana/login/models/paymentmethod.dart';
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
      paymentMethods: [
        PaymentMethod(type: 'Master Card', details: '••••  ••••  ••••  5678'),
      ],
      deliveryMethods: [
        DeliveryMethod(type: 'DHL', description: 'Fast', timeFrame: '2-3 days', price: 5.0)
      ]
    ),
    User(
      userId: 'u002', 
      email: 'test@banana.com', 
      password: '12345', 
      nickname: '테스트',
      address: '서울 강남구 테헤란로 123',
      location: '서울 강남구',
      profileImageUrl: '',
      orderHistory: [],
      sellingProducts: [],
      paymentMethods: [
        PaymentMethod(type: 'Visa', details: '••••  ••••  ••••  9012'),
      ],
      deliveryMethods: [
        DeliveryMethod(type: 'FedEx', description: 'Express', timeFrame: '1-2 days', price: 7.0)
      ]
    ),
    User(
      userId: 'u003', 
      email: 'user@banana.com', 
      password: '12345', 
      nickname: '사용자',
      address: '부산 해운대구 해운대로 456',
      location: '부산 해운대구',
      profileImageUrl: 'https://via.placeholder.com/150/FF6B6B/FFFFFF?text=U',
      orderHistory: [],
      sellingProducts: [],
      paymentMethods: [
        PaymentMethod(type: 'American Express', details: '••••  ••••  ••••  3456'),
      ],
      deliveryMethods: [
        DeliveryMethod(type: 'UPS', description: 'Standard', timeFrame: '3-5 days', price: 3.0)
      ]
    )
  ];
  
  // 현재 로그인된 사용자를 추적
  User? _currentUser;

  @override
  Future<void> addUser(User user) async{
    await Future.delayed(const Duration(milliseconds: 300));
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
    final user = _users.where((u) => u.email == email && u.password == password).firstOrNull;
    if (user != null) {
      _currentUser = user; // 로그인 성공 시 현재 사용자로 설정
    }
    return user;
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
      // 현재 사용자가 업데이트된 사용자라면 _currentUser도 업데이트
      if (_currentUser?.userId == updatedUser.userId) {
        _currentUser = updatedUser;
      }
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
      // 현재 사용자의 주문이라면 _currentUser도 업데이트
      if (_currentUser?.userId == userId) {
        _currentUser = updatedUser;
      }
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
      // 현재 사용자의 상품이라면 _currentUser도 업데이트
      if (_currentUser?.userId == userId) {
        _currentUser = updatedUser;
      }
    }
  }

  @override
  Future<User> getCurrentUser() async {
    await Future.delayed(Duration(milliseconds: 300));
    // 현재 로그인된 사용자가 있으면 반환, 없으면 첫 번째 사용자 반환
    return _currentUser ?? _users.first;
  }
  
  // 로그아웃 메서드 추가
  Future<void> logout() async {
    _currentUser = null;
  }
}