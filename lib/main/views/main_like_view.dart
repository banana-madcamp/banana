import 'dart:async';

import 'package:banana/login/datas/source/user_database_source.dart';
import 'package:banana/main/datas/source/database_source.dart';
import 'package:banana/main/models/product.dart';
import 'package:banana/utils/values/app_colors.dart';
import 'package:banana/utils/values/app_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../app_pages.dart';

class MainLikeView extends StatefulWidget {
  const MainLikeView({super.key});

  @override
  State<MainLikeView> createState() => _MainLikeViewState();
}

class _MainLikeViewState extends State<MainLikeView> {
  List<Product> likedProducts = [];
  late Logger log;
  late DatabaseSource db;
  late UserDatabaseSource userDb;
  bool _loading = true;
  late StreamSubscription _allProductsSubscription;
  late StreamSubscription _likedProductsSubscription;

  @override
  void initState() {
    super.initState();
    log = Get.find<Logger>(tag: "MainLogger");
    db = Get.find<DatabaseSource>();
    userDb = Get.find<UserDatabaseSource>();

    _loadLikedProducts();

    _allProductsSubscription = db.fetchItems().listen(
      (allProducts) async {
        await _loadLikedProducts();
      },
      onError: (error) {
        log.e('Error fetching products: $error');
        setState(() {
          _loading = false;
        });
      },
    );

    _likedProductsSubscription = userDb.likedProductsStream.listen(
      (likedProductIds) async {
        await _loadLikedProducts();
      },
      onError: (error) {
        log.e('Error listening to liked products: $error');
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      _loadLikedProducts();
    }
  }

  void refreshLikedProducts() {
    _loadLikedProducts();
  }

  Future<void> _loadLikedProducts() async {
    try {
      final allProducts = await db.fetchItems().first;
      final likedProductIds = await userDb.getLikedProducts();

      final filteredProducts =
          allProducts
              .where((product) => likedProductIds.contains(product.id))
              .toList();

      if (mounted) {
        setState(() {
          likedProducts = filteredProducts;
          _loading = false;
        });
      }
    } catch (error) {
      log.e('Error filtering liked products: $error');
      if (mounted) {
        setState(() {
          likedProducts = [];
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _allProductsSubscription.cancel();
    _likedProductsSubscription.cancel(); // 추가
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Row(
            children: [
              const Expanded(
                child: Center(
                  child: Text(
                    "Liked Products",
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.white,
              AppColors.white,
              AppColors.primary.withValues(alpha: 0.4),
            ],
          ),
        ),
        child:
            likedProducts.isEmpty && !_loading
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(AppIcons.heart, size: 80, color: AppColors.iconGray),
                      const SizedBox(height: 16),
                      Text(
                        'No liked products',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.iconGray,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add liked products to see them here',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.iconGray,
                        ),
                      ),
                    ],
                  ),
                )
                : Skeletonizer(
                  enabled: _loading,
                  enableSwitchAnimation: true,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      if (_loading) {
                        final dummyProduct = Product(
                          id: 'dummy',
                          title: 'Loading Product...',
                          description: 'Loading description...',
                          price: 0,
                          thumbnailImageUrl: '',
                          userId: '',
                          subTitle: 'Loading subtitle...',
                          tag: ['loading'],
                          location: 'Loading location...',
                          createdAt: DateTime.now(),
                          imageUrls: [],
                        );
                        return _buildProductItem(dummyProduct);
                      }
                      final product = likedProducts[index];
                      return _buildProductItem(product);
                    },
                    itemCount: _loading ? 5 : likedProducts.length,
                  ),
                ),
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27.5, vertical: 10),
      child: GestureDetector(
        onTap: () async {
          await Get.toNamed(Routes.PRODUCTDETAIL, arguments: product);
          _loadLikedProducts();
        },
        child: Container(
          width: 320,
          height: 142,
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:
                        product.thumbnailImageUrl.isEmpty
                            ? Container(
                              decoration: BoxDecoration(
                                color: AppColors.gray.withAlpha(80),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.image,
                                color: AppColors.darkGray,
                                size: 32,
                              ),
                            )
                            : CachedNetworkImage(
                              imageUrl: product.thumbnailImageUrl,
                              width: 68,
                              height: 68,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                    child: CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                      color: AppColors.primary,
                                    ),
                                  ),
                            ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                          height: 18 / 14,
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "게시일 : ${product.createdAt.toLocal().toString().split(' ')[0]}",
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: AppColors.gray,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          for (final tag in product.tag)
                            Text(
                              "#$tag",
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: AppColors.black,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${NumberFormat('#,##,###').format(product.price)} 원",
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.black,
                            ),
                          ),
                          Text(
                            product.location,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
