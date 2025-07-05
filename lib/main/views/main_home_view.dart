import 'package:banana/utils/values/app_assets.dart';
import 'package:banana/utils/values/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../utils/values/app_colors.dart';
import '../datas/source/database_source.dart';
import '../models/product.dart';

class MainHomeView extends StatefulWidget {
  const MainHomeView({super.key});

  @override
  State<MainHomeView> createState() => _MainHomeViewState();
}

class _MainHomeViewState extends State<MainHomeView> {
  List<Product> products = [];
  late Logger log;
  late DatabaseSource db;
  bool _loading = true;

  List<Product> dummyProducts = [
    for (int i = 0; i < 5; i++)
      Product(
        id: '1',
        title: 'Banana Chips - lorem ipsum dolor sit amet, consectetur',
        description: 'This is a dummy product description.',
        price: 1000,
        imageUrl: AppAssets.banana,
        userId: '',
        subTitle: 'this is a dummy product sub title',
        tag: ['dummy'],
        location: '대전 유성구',
        createdAt: DateTime.now(),
      ),
  ];

  @override
  void initState() {
    super.initState();
    log = Get.find<Logger>(tag: 'MainLogger');
    products = dummyProducts;
    db = Get.find<DatabaseSource>();
    db
        .fetchData()
        .then((value) {
          setState(() {
            _loading = false;
            products = value;
          });
        })
        .catchError((error) {
          setState(() {
            _loading = false;
            products = [];
          });
          log.e('Error fetching data: $error');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: Row(
            children: [
              const SizedBox(width: 16),
              Image.asset(width: 32, height: 32, AppAssets.logo),
            ],
          ),
        ),
        titleSpacing: 8,
        title: const Text(
          'Banana Market',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        backgroundColor: AppColors.white,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(AppIcons.search, size: 24, color: AppColors.black),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.white,
              AppColors.white,
              AppColors.primary.withOpacity(0.4),
            ],
          ),
        ),
        child: Skeletonizer(
          enabled: _loading,
          enableSwitchAnimation: true,
          child: ListView.builder(
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 27.5,
                  vertical: 10,
                ),
                child: Container(
                  width: 320,
                  height: 142,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(AppAssets.banana),
                                fit: BoxFit.cover,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
              );
            },
            itemCount: products.length,
          ),
        ),
      ),
    );
  }
}
