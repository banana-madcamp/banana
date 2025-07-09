import 'dart:async';

import 'package:banana/utils/values/app_assets.dart';
import 'package:banana/utils/values/app_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../customer/views/product_detail_page_view.dart';
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
  List<Product> _filteredProducts = [];
  late Logger log;
  late DatabaseSource db;
  bool _loading = true;
  late StreamSubscription _productsSubscription;
  bool _searching = false;
  final SearchController _searchController = SearchController();
  DateTime? _selectedDate;
  DateTime? targetDate;

  List<Product> dummyProducts = [
    for (int i = 0; i < 5; i++)
      Product(
        id: '1',
        title: 'Banana Chips - lorem ipsum dolor sit amet, consectetur',
        description: 'This is a dummy product description.',
        price: 1000,
        thumbnailImageUrl: AppAssets.banana,
        userId: '',
        subTitle: 'this is a dummy product sub title',
        tag: ['dummy'],
        location: '대전 유성구',
        createdAt: DateTime.now(),
        imageUrls: [],
      ),
  ];

  @override
  void initState() {
    super.initState();
    log = Get.find<Logger>(tag: 'MainLogger');
    products = dummyProducts;
    db = Get.find<DatabaseSource>();
    _productsSubscription = db.fetchItems().listen(
      (productsFromDb) {
        setState(() {
          products = productsFromDb;
          _loading = false;
        });
      },
      onError: (error) {
        log.e('Error fetching products: $error');
        setState(() {
          _loading = true;
        });
      },
    );
  }

  @override
  void dispose() {
    _productsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _searching
              ? AppBar(
                actions: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: IconButton(
                      onPressed: () {
                        showCupertinoDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 450,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        overlayColor:
                                            WidgetStateColor.resolveWith(
                                              (states) => AppColors.transparent,
                                            ),
                                      ),
                                      child: Text(
                                        "최소 날짜 선택",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 300,
                                      child: CupertinoDatePicker(
                                        mode: CupertinoDatePickerMode.date,
                                        dateOrder: DatePickerDateOrder.ymd,
                                        onDateTimeChanged: (DateTime value) {
                                          targetDate = value;
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        CupertinoButton(
                                          child: Text(
                                            "확인",
                                            style: TextStyle(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          onPressed: () {
                                            _selectedDate = targetDate;
                                            setState(() {
                                              _filteredProducts =
                                                  products.where((product) {
                                                    for (final tag
                                                        in product.tag) {
                                                      if (tag
                                                              .toLowerCase()
                                                              .contains(
                                                                _searchController
                                                                    .text
                                                                    .toLowerCase(),
                                                              ) &&
                                                          _selectedDate ==
                                                              null) {
                                                        return true;
                                                      } else if (tag
                                                              .toLowerCase()
                                                              .contains(
                                                                _searchController
                                                                    .text
                                                                    .toLowerCase(),
                                                              ) &&
                                                          _selectedDate !=
                                                              null) {
                                                        if (product.createdAt
                                                            .isAfter(
                                                              _selectedDate!,
                                                            )) {
                                                          return true;
                                                        }
                                                        return false;
                                                      }
                                                    }
                                                    return false;
                                                  }).toList();
                                              Get.back();
                                            });
                                          },
                                        ),
                                        CupertinoButton(
                                          child: Text(
                                            "취소",
                                            style: TextStyle(
                                              color: AppColors.gray,
                                            ),
                                          ),
                                          onPressed: () {
                                            Get.back();
                                            setState(() {
                                              _selectedDate = null;
                                              _filteredProducts =
                                                  products.where((product) {
                                                    for (final tag
                                                        in product.tag) {
                                                      if (tag
                                                          .toLowerCase()
                                                          .contains(
                                                            _searchController
                                                                .text
                                                                .toLowerCase(),
                                                          )) {
                                                        return true;
                                                      }
                                                    }
                                                    return false;
                                                  }).toList();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(
                        AppIcons.tune,
                        size: 30,
                        color: AppColors.white,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 26),
                ],
                backgroundColor: AppColors.white,
                title: Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: SearchBar(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _filteredProducts =
                            products.where((product) {
                              for (final tag in product.tag) {
                                if (tag.toLowerCase().contains(
                                      value.toLowerCase(),
                                    ) &&
                                    _selectedDate == null) {
                                  return true;
                                } else if (tag.toLowerCase().contains(
                                      value.toLowerCase(),
                                    ) &&
                                    _selectedDate != null) {
                                  if (product.createdAt.isAfter(
                                    _selectedDate!,
                                  )) {
                                    return true;
                                  }
                                  return false;
                                }
                              }
                              return false;
                            }).toList();
                      });
                    },
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      AppColors.lightGray,
                    ),
                    textStyle: WidgetStatePropertyAll(
                      TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppColors.black,
                      ),
                    ),
                    hintText: "Search...",
                    hintStyle: WidgetStatePropertyAll(
                      TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppColors.gray,
                      ),
                    ),
                    elevation: WidgetStatePropertyAll(0),
                    leading: IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.text = "";
                          _filteredProducts = [];
                          _searching = false;
                        });
                      },
                      icon: Icon(AppIcons.search),
                    ),
                  ),
                ),
              )
              : AppBar(
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
                    onPressed: () {
                      setState(() {
                        _searching = true;
                      });
                    },
                    icon: Icon(
                      AppIcons.search,
                      size: 24,
                      color: AppColors.black,
                    ),
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
              AppColors.primary.withValues(alpha: 0.4),
            ],
          ),
        ),
        child: Skeletonizer(
          enabled: _loading,
          enableSwitchAnimation: true,
          child: ListView.builder(
            itemBuilder: (context, index) {
              final product =
                  _searchController.text == "" && _selectedDate == null
                      ? products[index]
                      : _filteredProducts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 27.5,
                  vertical: 10,
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => ProductDetailView(), arguments: product);
                  },
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
                                  image: CachedNetworkImageProvider(
                                    product.thumbnailImageUrl,
                                  ),
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
                                      "${NumberFormat('###,###,###,###').format(product.price)} 원",
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
            },
            itemCount:
                _searchController.text == "" && _selectedDate == null
                    ? products.length
                    : _filteredProducts.length,
          ),
        ),
      ),
    );
  }
}
