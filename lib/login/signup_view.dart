import 'package:banana/utils/values/app_colors.dart';
import 'package:banana/utils/values/app_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool _isObscured = true;
  bool _isConfirmObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Spacer(),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Sign up",
                    style: TextStyle(fontSize: 32, fontWeight:FontWeight.w700)),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(height: 2, width: 80, color: AppColors.primary),
                ),
                const SizedBox(height: 36),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Nickname", style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                TextFormField(
                  controller: nicknameController,
                  decoration: const InputDecoration(
                    hintText: "enter your nickname",
                    hintStyle: TextStyle(color: AppColors.gray),
                    prefixIcon: Icon(AppIcons.profile, color: AppColors.gray),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.gray, width: 1.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  validator: (value) =>
                    value == null || value.isEmpty ? '닉네임을 입력해주세요' : null,
                ),
                const SizedBox(height: 24),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Email", style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: "enter your email",
                    hintStyle: TextStyle(color: AppColors.gray),
                    prefixIcon: Icon(AppIcons.email, color: AppColors.gray),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.gray, width: 1.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return '이메일을 입력해주세요';
                    if (!value.contains('@')) return '유효한 이메일 형식이 아닙니다';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Password", style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                    hintText: "enter your password",
                    hintStyle: const TextStyle(color: AppColors.gray),
                    prefixIcon: const Icon(AppIcons.password, color: AppColors.gray),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _isObscured = !_isObscured),
                      icon: Icon(
                        _isObscured ? AppIcons.invisible : AppIcons.visible,
                        color: AppColors.gray,
                      ),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.gray, width: 1.5),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Confirm Password", style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                TextFormField(
                  controller: confirmController,
                  obscureText: _isConfirmObscured,
                  decoration: InputDecoration(
                    hintText: "confirm your password",
                    hintStyle: const TextStyle(color: AppColors.gray),
                    prefixIcon: const Icon(AppIcons.password, color: AppColors.gray),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _isConfirmObscured = !_isConfirmObscured),
                      icon: Icon(
                        _isConfirmObscured ? AppIcons.invisible : AppIcons.visible,
                        color: AppColors.gray,
                      ),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.gray, width: 1.5),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value != passwordController.text) {
                      return '비밀번호가 일치하지 않습니다';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                ElevatedButton(onPressed: () {
                  if (_formKey.currentState!.validate()) {}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text("Create Account",
                    style: TextStyle(color: AppColors.white)),
              ),
              const SizedBox(height: 16),

              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(color: AppColors.gray),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w400,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                          }
                        ),
                      ],
                    ),
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