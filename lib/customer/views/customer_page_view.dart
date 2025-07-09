import 'package:banana/login/datas/source/user_database_source.dart';
import 'package:banana/login/models/deliverymethod.dart';
import 'package:banana/login/models/order.dart';
import 'package:banana/login/models/paymentmethod.dart';
import 'package:banana/login/models/user.dart';
import 'package:banana/main/datas/source/database_source.dart';
import 'package:banana/main/models/product.dart';
import 'package:banana/utils/values/app_colors.dart';
import 'package:banana/utils/values/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_pages.dart';

class CustomerPageView extends StatefulWidget {
  const CustomerPageView({super.key});

  @override
  State<CustomerPageView> createState() => _CustomerPageViewState();
}

class _CustomerPageViewState extends State<CustomerPageView> {
  late Future<User> _userFuture;
  Product? selectedProduct;
  String? selectedAddress;
  PaymentMethod? selectedPaymentMethod;
  DeliveryMethod? selectedDeliveryMethod;

  UserDatabaseSource get _userDb => Get.find<UserDatabaseSource>();

  DatabaseSource get _db => Get.find<DatabaseSource>();

  @override
  void initState() {
    super.initState();
    _userFuture = Future.value(_userDb.getCurrentUser());
    selectedProduct = Get.arguments as Product?;
  }

  Future<void> _submitOrder(User user) async {
    final selectedDelivery =
        selectedDeliveryMethod ??
        (user.deliveryMethods.isNotEmpty ? user.deliveryMethods.first : null);

    try {
      final order = Order(
        orderId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.userId,
        product: selectedProduct!,
        orderedAt: DateTime.now(),
        orderAmount: selectedProduct!.price,
        deliveryPrice: selectedDelivery!.price,
        totalAmount: selectedProduct!.price + selectedDelivery.price,
      );

      await _userDb.addOrder(user.userId, order).then((_) {
        _db.purchaseProduct(selectedProduct!.id, user.userId);
      });

      _showSuccessSnackBar();

      Get.until((route) => Get.currentRoute == Routes.MAIN);
    } catch (error) {
      Get.dialog(
        CupertinoAlertDialog(
          title: const Text(
            '주문 실패',
            style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.w600),
          ),
          content: const Text(
            '주소, 결제 수단, 또는 배송 방법이 선택되지 않았습니다.',
            style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.w400),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Get.back(),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  void _showAddressEditDialog(User user) {
    final TextEditingController addressController = TextEditingController(
      text: selectedAddress ?? user.address,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              '배송지 편집',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w600,
              ),
            ),
            content: TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: '주소',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('취소')),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedAddress = addressController.text;
                  });
                  Get.back();
                },
                child: const Text('저장'),
              ),
            ],
          ),
    );
  }

  void _showPaymentMethodDialog(User user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              '결제 방법 선택',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w600,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: user.paymentMethods.length,
                itemBuilder: (context, index) {
                  final payment = user.paymentMethods[index];
                  final isSelected = selectedPaymentMethod == payment;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? AppColors.primary.withAlpha(40) : null,
                      borderRadius: BorderRadius.circular(8),
                      border:
                          isSelected
                              ? Border.all(color: AppColors.primary, width: 1)
                              : null,
                    ),
                    child: ListTile(
                      leading: _buildPaymentLogo(payment.type),
                      subtitle: Text(
                        '**** / ${payment.details.substring(payment.details.length - 4)}',
                      ),
                      onTap: () {
                        setState(() {
                          selectedPaymentMethod = payment;
                        });
                        Get.back();
                      },
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('취소')),
            ],
          ),
    );
  }

  void _showDeliveryMethodDialog(User user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text(
              '배송 방법 선택',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w600,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: user.deliveryMethods.length,
                itemBuilder: (context, index) {
                  final delivery = user.deliveryMethods[index];
                  final isSelected = selectedDeliveryMethod == delivery;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? AppColors.primary.withAlpha(40) : null,
                      borderRadius: BorderRadius.circular(8),
                      border:
                          isSelected
                              ? Border.all(color: AppColors.primary, width: 1)
                              : null,
                    ),
                    child: ListTile(
                      leading: _buildDeliveryLogo(delivery.type),
                      title: Text(
                        delivery.type.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(delivery.timeFrame),
                      trailing: Text(
                        '\$${delivery.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        setState(() {
                          selectedDeliveryMethod = delivery;
                        });
                        Get.back();
                      },
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('취소')),
            ],
          ),
    );
  }

  void _showSuccessSnackBar() {
    Get.dialog(
      CupertinoAlertDialog(
        title: const Text(
          '주문 성공',
          style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.w600),
        ),
        content: const Text(
          '주문이 성공적으로 접수되었습니다.',
          style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.w400),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Get.back(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: FutureBuilder<User>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            final currentUser = snapshot.data!;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
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
                          child: Text(
                            "Check out",
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

                          _buildSection(
                            "Shipping Address",
                            () => _showAddressEditDialog(currentUser),
                          ),
                          const SizedBox(height: 16),
                          _buildAddressCard(currentUser),
                          const SizedBox(height: 20),

                          _buildSection(
                            "Payment",
                            () => _showPaymentMethodDialog(currentUser),
                          ),
                          const SizedBox(height: 16),
                          _buildPaymentCard(currentUser),
                          const SizedBox(height: 20),

                          _buildSection(
                            "Delivery method",
                            () => _showDeliveryMethodDialog(currentUser),
                          ),
                          const SizedBox(height: 16),
                          _buildDeliveryCard(currentUser),
                          const SizedBox(height: 20),

                          _buildOrderSummary(currentUser),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: () => _submitOrder(currentUser),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      maximumSize: Size(double.infinity, 49),
                      minimumSize: Size(double.infinity, 49),
                    ),
                    child: const Text(
                      "SUBMIT ORDER",
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(String title, VoidCallback onEditTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.primary,
          ),
        ),
        GestureDetector(
          onTap: onEditTap,
          child: Icon(AppIcons.edit, color: AppColors.iconGray, size: 24),
        ),
      ],
    );
  }

  Widget _buildAddressCard(User user) {
    final displayAddress = selectedAddress ?? user.address;

    return Container(
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
          Text(
            user.nickname,
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 10),
          Container(height: 1, width: double.infinity, color: AppColors.gray),
          const SizedBox(height: 10),
          Text(
            displayAddress.isNotEmpty ? displayAddress : "주소를 등록해주세요.",
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(User user) {
    final paymentMethod =
        selectedPaymentMethod ??
        (user.paymentMethods.isNotEmpty ? user.paymentMethods.first : null);

    if (paymentMethod == null) {
      return Container(
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
        child: const Text(
          "등록된 결제 수단이 없습니다.",
          style: TextStyle(
            fontFamily: 'Rubik',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.gray,
          ),
        ),
      );
    }
    return Container(
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
      child: Row(
        children: [
          _buildPaymentLogo(paymentMethod.type),
          const SizedBox(width: 50),
          Text(
            paymentMethod.details,
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentLogo(String type) {
    switch (type.toLowerCase()) {
      case 'master card':
      case 'mastercard':
        return Container(
          width: 100,
          height: 38,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEB001B), Color(0xFFF79E18)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              "Master Card",
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
        );
      case 'visa':
        return Container(
          width: 100,
          height: 38,
          decoration: BoxDecoration(
            color: Color(0xFF1A1F71),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'VISA',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
        );
      case 'american express':
      case 'amex':
        return Container(
          width: 100,
          height: 38,
          decoration: BoxDecoration(
            color: Color(0xFF006FCF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'AMEX',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
        );
      default:
        return Container(
          width: 100,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.gray,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(Icons.credit_card, color: AppColors.white),
          ),
        );
    }
  }

  Widget _buildDeliveryCard(User user) {
    final deliveryMethod =
        selectedDeliveryMethod ??
        (user.deliveryMethods.isNotEmpty ? user.deliveryMethods.first : null);

    if (deliveryMethod == null) {
      return Container(
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
        child: const Text(
          "등록된 배송 방법이 없습니다.",
          style: TextStyle(
            fontFamily: 'Rubik',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.gray,
          ),
        ),
      );
    }
    return Container(
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
      child: Row(
        children: [
          _buildDeliveryLogo(deliveryMethod.type),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${deliveryMethod.description} (${deliveryMethod.timeFrame})",
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${deliveryMethod.price.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} 원",
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryLogo(String deliverytype) {
    Color logoColor;
    Color textColor;
    String displayText;

    switch (deliverytype.toLowerCase()) {
      case 'dhl':
        logoColor = const Color(0xFFFFCC00);
        textColor = const Color(0xFFD40511);
        displayText = 'DHL';
        break;
      case 'fedex':
        logoColor = const Color(0xFF4D148C);
        textColor = AppColors.white;
        displayText = 'FedEx';
        break;
      case 'ups':
        logoColor = const Color(0xFF8B4513);
        textColor = AppColors.white;
        displayText = 'UPS';
        break;
      default:
        logoColor = AppColors.gray;
        textColor = AppColors.white;
        displayText = deliverytype.substring(0, 2).toUpperCase();
    }

    return Container(
      width: 100,
      height: 38,
      decoration: BoxDecoration(
        color: logoColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          displayText,
          style: TextStyle(
            fontFamily: 'Rubik',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(User user) {
    final orderAmount = selectedProduct?.price ?? 0.0;
    final selectedDelivery =
        selectedDeliveryMethod ??
        (user.deliveryMethods.isNotEmpty ? user.deliveryMethods.first : null);
    final deliveryPrice = selectedDelivery?.price ?? 0.0;
    final totalAmount = orderAmount + deliveryPrice;

    return Container(
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
        children: [
          _buildSummaryRow(
            "Order:",
            "${orderAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} 원",
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            "Delivery:",
            "${deliveryPrice.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} 원",
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            "Total:",
            "${totalAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} 원",
            isTotal: true,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Rubik',
            fontSize: 18,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: isTotal ? AppColors.black : AppColors.gray,
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontFamily: 'Rubik',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
