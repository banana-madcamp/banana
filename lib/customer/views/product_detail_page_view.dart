import 'package:banana/customer/views/customer_page_view.dart';
import 'package:banana/login/datas/source/user_database_source.dart';
import 'package:banana/login/models/user.dart';
import 'package:banana/main/models/product.dart';
import 'package:banana/utils/values/app_colors.dart';
import 'package:banana/utils/values/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  Product? product;
  bool isLiked = false;
  int currentImageIndex = 0;
  late Future<User?> _sellerFuture;

  UserDatabaseSource get _userDb => Get.find<UserDatabaseSource>();

  @override
  void initState() {
    super.initState();
    product = Get.arguments as Product?;
    _sellerFuture = product != null
        ? _userDb.getUserById(product!.userId)
        : Future.value(null);
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  int _getImageCount() {
    if (product?.imageUrls != null && product!.imageUrls.isNotEmpty) {
      return product!.imageUrls.length;
    }
    return 1;
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(
                    AppIcons.back,
                    color: AppColors.black,
                    size: 20,
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: SizedBox(), 
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                  
                  Column(  
                    children: [
                      SizedBox(
                        height: 380,
                        width: double.infinity,
                        child: Stack(
                          children: [ 
                            PageView.builder(
                              itemCount : _getImageCount(),
                              onPageChanged: (index) {
                                setState(() {
                                  currentImageIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                String imageUrl = '';
                                if(product?.imageUrls != null && product!.imageUrls.isNotEmpty
                                  && index < product!.imageUrls.length) {
                                    imageUrl = product!.imageUrls[index];
                                  } else {
                                    imageUrl = product?.thumbnailImageUrl ?? '';
                                  }
                          
                                return Image.network(
                                  imageUrl,
                                  height: 380,
                                  width: 380,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 380,
                                      width: 380,
                                      color: AppColors.gray.withAlpha(40),
                                      child: Icon(
                                        Icons.image,
                                        size: 80,
                                        color: AppColors.darkGray,
                                      ),
                                    );
                                  },
                                );
                              }
                            ),
                            _buildSellerInfoOverlay(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12), 

                      if (_getImageCount() >= 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _getImageCount(),
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == currentImageIndex
                                    ? AppColors.primary
                                    : AppColors.gray,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  product?.title ?? '',
                                  style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              Text(
                                product?.createdAt != null 
                                    ? _formatDate(product!.createdAt) 
                                    : '날짜 없음',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.gray,
                                ),
                              ),
                            ],
                          ),

                          if (product != null && product!.tag.isNotEmpty)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: product!.tag.map((tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(40),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.darkGray,
                                  ),
                                ),
                              )).toList(),
                            ),
                        const SizedBox(height: 12),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(40),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product?.subTitle ?? 'no subtitle',
                                style: const TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF616161),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                (product != null && product!.description.isNotEmpty) 
                                    ? product!.description
                                    : 'no description',
                                style: const TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.darkGray,
                                ),
                              ),

                              const SizedBox(height: 24),
                              
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${(product?.price ?? 0).toInt().toString().replaceAllMapped(
                                    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                                    (Match m) => '${m[1]},',
                                  )} 원',
                                  style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: _toggleLike,
                              child: AnimatedContainer(duration: Duration(milliseconds: 200),
                              width: 60,
                              height: 60,
                              child: Icon(
                                isLiked ? AppIcons.heartEnabled : AppIcons.heart,
                                color: isLiked ? AppColors.logo: AppColors.gray,
                                size: 42,
                              )
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(
                                  () => const CustomerPageView(),
                                  arguments: product,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                maximumSize: Size(double.infinity, 49),
                                minimumSize: Size(double.infinity, 49),
                              ),
                              child: const Text(
                                'BUY NOW !',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],  
    ),),);                                        
  }

  Widget _buildSellerInfoOverlay() {
  return Positioned(
    top: 16,
    left: 16,
    right: 16,
    child: FutureBuilder<User?>(
      future: _sellerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }

        final seller = snapshot.data;
        if (seller == null) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(140), 
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.white,
                backgroundImage: seller.profileImageUrl.isNotEmpty
                    ? NetworkImage(seller.profileImageUrl)
                    : null,
                child: seller.profileImageUrl.isEmpty
                    ? Icon(
                        AppIcons.profile,
                        color: AppColors.iconGray,
                        size: 24,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      seller.nickname,
                      style: const TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          seller.location.isNotEmpty ? seller.location : product?.location ?? '',
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 14, 
                            fontWeight: FontWeight.w400,
                            color: AppColors.gray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
  }
}