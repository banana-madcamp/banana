import 'dart:io';

import 'package:banana/main/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../source/database_source.dart';

class DatabaseSourceImpl extends DatabaseSource {
  final _db = FirebaseFirestore.instance;
  final _storage = Supabase.instance.client;
  final Logger log = Logger();

  @override
  Stream<List<Product>> fetchItems() {
    return _db.collection('items').snapshots().map((snapshot) {
      List<Product> products =
          snapshot.docs.map((doc) {
            return Product.fromJson(doc.data());
          }).toList();
      products.sort(
        (a, b) =>
            b.createdAt.compareTo(a.createdAt), // Sort by createdAt descending
      );
      return products;
    });
  }

  @override
  Future<List<String>> uploadImages(String productId, List<File> images) async {
    List<String> imageUrls = [];
    for (int i = 0; i < images.length; i++) {
      final imageFile = images[i];
      final filePath = "$productId/$i.png";
      await _storage.storage.from("products").upload(filePath, imageFile);
      imageUrls.add(
        await _storage.storage.from('products').getPublicUrl(filePath),
      );
    }
    return imageUrls;
  }

  @override
  Future<void> uploadProduct(Product product) {
    return _db
        .collection('items')
        .doc(product.id)
        .set(product.toJson())
        .then((_) {
          log.i('Product uploaded successfully: ${product.id}');
          _db
              .collection('users')
              .doc(product.userId)
              .update({
                'sellingProducts': FieldValue.arrayUnion([product.toJson()]),
              })
              .then((_) {
                log.i(
                  'Product added to user selling products: ${product.userId}',
                );
              })
              .catchError((error) {
                log.e('Failed to update user selling products: $error');
              });
        })
        .catchError((error) {
          log.e('Failed to upload product: $error');
          throw Exception('Failed to upload product: $error');
        });
  }

  @override
  Future<void> deleteProduct(String productId) {
    return _db
        .collection('items')
        .doc(productId)
        .delete()
        .then((_) {
          log.i('Product deleted successfully: $productId');
        })
        .catchError((error) {
          log.e('Failed to delete product: $error');
          throw Exception('Failed to delete product: $error');
        });
  }

  @override
  Future<void> editProduct(String productId, Product product) {
    return _db
        .collection('items')
        .doc(productId)
        .update(product.toJson())
        .then((_) {
          log.i('Product edited successfully: $productId');
        })
        .catchError((error) {
          log.e('Failed to edit product: $error');
          throw Exception('Failed to edit product: $error');
        });
  }

  @override
  Future<void> purchaseProduct(String productId, String userId) async {
    ;
    _db.collection('items').doc(productId).get().then((doc) {
      if (doc.exists) {
        _db.collection('purchased_items').doc(productId).set(doc.data()!);
        deleteProduct(productId);
      }
    });
  }
}
