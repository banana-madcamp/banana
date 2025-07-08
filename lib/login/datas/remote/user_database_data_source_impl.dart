import 'dart:async';

import 'package:banana/login/datas/source/user_database_source.dart';
import 'package:banana/login/models/order.dart';
import 'package:banana/login/models/user.dart';
import 'package:banana/main/datas/source/database_source.dart';
import 'package:banana/main/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class UserDatabaseDataSourceImpl implements UserDatabaseSource {
  final _auth = FirebaseAuth.instance;
  final log = Logger();
  final _db = FirebaseFirestore.instance;
  final storage = FlutterSecureStorage();

  @override
  Future<void> addOrder(String userId, Order order) {
    return _db.collection('users').doc(userId).update({
      'orderHistory': FieldValue.arrayUnion([order.toJson()])
    }).then((_) {
      log.i('Order added successfully for user: $userId');
    }).catchError((error) {
      log.e('Error adding order: $error');
    });
  }

  void saveAuthToken(String email, String password) {
    storage.write(key: 'email', value: email);
    storage.write(key: 'password', value: password);
  }

  @override
  Future<User?> addUser(String email, String password, String nickname) {
    return _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((userCredential) async {
          final user = userCredential.user;
          if (user == null) {
            log.e('User not found');
            return null;
          }

          final User newUser = User(
            userId: user.uid,
            email: email,
            nickname: nickname,
            address: '',
            location: '',
            profileImageUrl: '',
            orderHistory: [],
            sellingProducts: [],
            paymentMethods: [],
          );

          final User returnUser = await _db
              .collection('users')
              .doc(user.uid)
              .set(newUser.toJson())
              .then((_) {
                log.i('User added successfully: ${newUser.userId}');
                saveAuthToken(email, password);
                return newUser;
              })
              .catchError((error) {
                log.e('Error adding user: $error');
              });
          return returnUser;
        })
        .catchError((error) {
          // Handle error
          log.e('Error finding user: $error');
          return null;
        });
  }

  @override
  Future<User?> autoLogin() async {
    String? email = await storage.read(key: 'email');
    String? password = await storage.read(key: 'password');
    if (email == null || password == null) {
      return null;
    } else {
      return findUser(email, password);
    }
  }

  @override
  Future<void> deleteUser(String userId) {
    _db.collection('users').doc(userId).delete();
    return _auth.currentUser!.delete();
  }

  @override
  Future<List<User>> fetchUsers() {
    // TODO: implement fetchUsers
    throw UnimplementedError();
  }

  @override
  Future<User?> findUser(String email, String password) {
    return _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
          final user = userCredential.user;
          if (user == null) {
            log.e('User not found');
            return null;
          }
          return _db.collection('users').doc(user.uid).get().then((doc) {
            if (doc.exists) {
              saveAuthToken(email, password);
              return User.fromJson(doc.data()!);
            } else {
              log.e('User document does not exist');
              return null;
            }
          });
        })
        .catchError((error) {
          // Handle error
          log.e('Error finding user: $error');
          return null;
        });
  }

  @override
  Future<User> getCurrentUser() {
    final user = _auth.currentUser;
    return _db
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((doc) {
          if (doc.exists) {
            return User.fromJson(doc.data()!);
          } else {
            log.e('User document does not exist');
            throw Exception('User document does not exist');
          }
        })
        .catchError((error) {
          log.e('Error fetching current user: $error');
          throw error;
        });
  }

  @override
  Future<void> logout() {
    return _auth.signOut();
  }

  @override
  Future<void> updateUser(User updatedUser) {
    return _db
        .collection('users')
        .doc(updatedUser.userId)
        .update(updatedUser.toJson())
        .then((_) {
          log.i('User updated successfully: ${updatedUser.userId}');
        })
        .catchError((error) {
          log.e('Error updating user: $error');
        });
  }
}
