import 'package:banana/login/datas/local/user_database_data_source_dummy.dart';
import 'package:banana/login/datas/source/user_database_source.dart';
import 'package:banana/utils/values/app_colors.dart';
import 'package:banana/utils/values/app_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

final UserDatabaseSource userDB = UserDatabaseSourceDummy();

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                child: Text("Sign In",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(height: 2, width: 80, color: AppColors.primary),
              ),
              const SizedBox(height: 36),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Email", style: TextStyle(fontWeight: FontWeight.w600)),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "enter your email",
                  hintStyle: const TextStyle(color: AppColors.gray),
                  prefixIcon: const Icon(AppIcons.email, color: AppColors.gray),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.gray, width: 1.5),
                  ),
                  focusedBorder: const UnderlineInputBorder(
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
        
              const SizedBox(height: 12),
        
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe, 
                    onChanged: (value) => setState(() => _rememberMe = value ?? false),
                    activeColor: AppColors.primary,
                    checkColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),  
                  ),
                  const Text("Remember Me", style: TextStyle(fontWeight: FontWeight.w400),),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final email = emailController.text;
                    final password = passwordController.text;

                    final user = await userDB.findUser(email, password);

                    if(user!= null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${user.nickname}님, 로그인 성공 !")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("이메일 또는 비밀번호가 일치하지 않습니다")),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text("Login", style: TextStyle(color: AppColors.white)),
              ),
              const SizedBox(height: 16),

              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(color: AppColors.gray),
                    children: [
                      TextSpan(
                        text: "Sign up",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w400, 
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/signup');
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],),
          ),
        ),
      ),
    );
  }
}