import 'package:banana/login/datas/source/user_database_source.dart';
import 'package:banana/login/models/user.dart';
import 'package:banana/utils/values/app_colors.dart';
import 'package:banana/utils/values/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainProfileView extends StatefulWidget {
  const MainProfileView({super.key});

  @override
  State<MainProfileView> createState() => _MainProfileViewState();
}

class _MainProfileViewState extends State<MainProfileView> {
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    final userDB = Get.find<UserDatabaseSource>();
    _userFuture = Future.value(userDB.getCurrentUser());
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
                            backgroundColor:AppColors.white,
                            backgroundImage: currentUser.profileImageUrl.isNotEmpty
                                ? NetworkImage(currentUser.profileImageUrl)
                                : null,
                            child: currentUser.profileImageUrl.isEmpty
                                ? Icon(AppIcons.profile, color: AppColors.iconGray, size: 64)
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
                                const Icon(AppIcons.edit, size: 14, color: AppColors.iconGray) 
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
                  const SizedBox(height: 80),
                
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          _buildMenuItem(icon: AppIcons.password, label: "Change Password", onTap: () {}),
                          _buildMenuItem(icon: AppIcons.sales, label: "My Sales", onTap: () {}),
                          _buildMenuItem(icon: AppIcons.shoppingBag, label: "My Order", onTap: () {}),
                          _buildMenuItem(icon: AppIcons.location, label: "Edit Location", onTap: () {}),
                          _buildMenuItem(icon: AppIcons.deleteAccount, label: "Delete Account", onTap: () {}),

                          const Spacer(),
                        
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 80),
                              child: GestureDetector(
                                onTap: () {},
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(AppIcons.logout, color: AppColors.iconGray),
                                    SizedBox(height: 4),
                                    Text(
                                      "Logout",
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600
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