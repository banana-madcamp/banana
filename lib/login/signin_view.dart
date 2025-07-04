import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            
            children: [
              const SizedBox(height: 60),
              const Text("Sign In", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),),
              const SizedBox(height: 5,),
              Container(height: 2, width:50, color: Color(0xFFFF8383),),
              const SizedBox(height: 24),

              const Text("Email", style: TextStyle(fontWeight:FontWeight.w600),),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "enter your email",
                  prefixIcon: Icon(Icons.email_outlined),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 2), 
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF8383), width: 2), 
                  ),
                ),
                validator: (value) {
                    if (value == null || value.isEmpty) return '이메일을 입력해주세요';
                    if (!value.contains('@')) return '유효한 이메일 형식이 아닙니다';
                    return null;
                  },              
              ),
              const SizedBox(height: 24),

              const Text("Password", style: TextStyle(fontWeight:FontWeight.w600),),
              TextField(
                controller: passwordController,
                obscureText: _isObscured,
                decoration: const InputDecoration(
                  hintText: "enter your password",
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    onPressed: onPressed, 
                    icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility_outlined))
                ),
              ),
            ],
        ))
    ),
    );
  }
}