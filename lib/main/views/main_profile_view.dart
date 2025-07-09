import 'package:banana/login/datas/source/user_database_source.dart';
import 'package:banana/login/models/user.dart';
import 'package:banana/login/views/signin_view.dart';
import 'package:banana/splash/views/splash_view.dart';
import 'package:banana/utils/values/app_colors.dart';
import 'package:banana/utils/values/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../app_pages.dart';

class MainProfileView extends StatefulWidget {
  const MainProfileView({super.key});

  @override
  State<MainProfileView> createState() => _MainProfileViewState();
}

class _MainProfileViewState extends State<MainProfileView> {
  late Future<User> _userFuture;
  final log = Logger();

  UserDatabaseSource get _userDb => Get.find<UserDatabaseSource>();

  @override
  void initState() {
    super.initState();
    _userFuture = _userDb.getCurrentUser();
  }

  void _showEditLocationDialog(User user) {
    final TextEditingController locationController = TextEditingController(
      text: user.location,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('위치 편집'),
            content: TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: '위치',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('취소')),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _userDb.updateUserLocation(
                      user.userId,
                      locationController.text,
                    );
                    setState(() {
                      _userFuture = _userDb.getCurrentUser();
                    });
                    Get.back();
                  } catch (error) {}
                },
                child: const Text('저장'),
              ),
            ],
          ),
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('비밀번호 변경'),
            content: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '새 비밀번호',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('취소')),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _userDb.changePassword(passwordController.text);
                    Get.back();
                  } catch (error) {}
                },
                child: const Text('변경'),
              ),
            ],
          ),
    );
  }

  void _showEditNickNameDialog(User user) {
    final TextEditingController nicknameController = TextEditingController(
      text: user.nickname,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              '닉네임 편집',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w600,
              ),
            ),
            content: TextField(
              controller: nicknameController,
              decoration: const InputDecoration(
                labelText: '닉네임',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('취소')),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _userDb.updateUserNickName(
                      user.userId,
                      nicknameController.text,
                    );
                    setState(() {
                      _userFuture = _userDb.getCurrentUser();
                    });
                    Get.back();
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('닉네임 변경 실패: $error')),
                    );
                  }
                },
                child: const Text('저장'),
              ),
            ],
          ),
    );
  }

  void _showDeleteAccountDialog(User user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              '계정 삭제',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            content: const Text(
              '정말로 계정을 삭제하시겠습니까?',
              style: TextStyle(fontFamily: 'Rubik'),
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('취소')),
              ElevatedButton(
                onPressed: () async {
                  try {
                    Get.back();

                    await _userDb.deleteUser(user.userId);

                    Get.offAllNamed(Routes.SPLASH);
                  } catch (error) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('계정 삭제 실패: $error')));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('삭제', style: TextStyle(color: Colors.white)),
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
        child: FutureBuilder(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(child: Text("사용자 정보를 불러올 수 없습니다."));
            }

            final currentUser = snapshot.data!;

            return Column(
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 114,
                        height: 114,
                        child: CircleAvatar(
                          backgroundColor: AppColors.white,
                          backgroundImage:
                              currentUser.profileImageUrl.isNotEmpty
                                  ? NetworkImage(currentUser.profileImageUrl)
                                  : null,
                          child:
                              currentUser.profileImageUrl.isEmpty
                                  ? Icon(
                                    AppIcons.profile,
                                    color: AppColors.iconGray,
                                    size: 64,
                                  )
                                  : null,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                currentUser.nickname,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  fontFamily: 'Rubik',
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap:
                                    () => _showEditNickNameDialog(currentUser),
                                child: const Icon(
                                  AppIcons.edit,
                                  size: 14,
                                  color: AppColors.iconGray,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            currentUser.email,
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          icon: AppIcons.password,
                          label: "Change Password",
                          onTap: () => _showChangePasswordDialog(),
                        ),
                        _buildMenuItem(
                          icon: AppIcons.sales,
                          label: "My Sales",
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: AppIcons.shoppingBag,
                          label: "My Order",
                          onTap: () async {
                            final user = await _userDb.getCurrentUser();
                            log.e(user.orderHistory);
                            Get.dialog(
                              AlertDialog(
                                title: Text('My Order'),
                                content: Container(
                                  height: 400,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListView(
                                    children: [
                                      for (var order in user.orderHistory)
                                        ListTile(
                                          title: Text(
                                            "주문 번호 : ${order.orderId}",
                                          ),
                                          subtitle: Text(order.product.title),
                                          trailing: Text(
                                            'Total: ${NumberFormat('###,###,###').format(order.product.price)}원',
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text('확인'),
                                    onPressed: () => Get.back(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: AppIcons.location,
                          label: "Edit Location",
                          onTap: () => _showEditLocationDialog(currentUser),
                        ),
                        _buildMenuItem(
                          icon: AppIcons.deleteAccount,
                          label: "Delete Account",
                          onTap: () => _showDeleteAccountDialog(currentUser),
                        ),

                        const Spacer(),

                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: GestureDetector(
                              onTap: () async {
                                try {
                                  await _userDb.logout();
                                  Get.offAllNamed(Routes.SIGNIN);
                                } catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('로그아웃 실패: $error')),
                                  );
                                }
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    AppIcons.logout,
                                    color: AppColors.iconGray,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Logout",
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Icon(icon, size: 30, color: AppColors.iconGray),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: AppColors.iconGray,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_outlined, color: AppColors.iconGray),
          ],
        ),
      ),
    );
  }
}
