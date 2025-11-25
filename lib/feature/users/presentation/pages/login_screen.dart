// Thay đổi đường dẫn import này cho đúng với project của bạn
import 'package:finance_tracking_app/feature/users/presentation/widgets/CustomTextField.dart';
import 'package:finance_tracking_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Biến trạng thái ẩn/hiện mật khẩu
  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Khởi tạo Widget ảnh từ Assets Gen
    // Đảm bảo Assets.images.loginImage tồn tại trong file assets.gen.dart
    Widget loginImage = Assets.images.loginImage.image(
      width: 240,
      height: 120,
      fit: BoxFit.contain, // Thêm fit để ảnh không bị méo
    );

    return Scaffold(
      backgroundColor: Colors.white, // Thêm màu nền trắng cho sạch
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40), // Thêm khoảng cách đầu trang

              const Text(
                'Welcome to Personal\nFinance Tracker',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 32),

              // Hiển thị ảnh
              Center(child: loginImage),

              const SizedBox(height: 32),

              // --- EMAIL FIELD ---
              CustomTextfield(
                controller: _emailController,
                hintText: 'Email',
                obscureText: false, // Email không cần ẩn ký tự
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              // --- PASSWORD FIELD ---
              CustomTextfield(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: _isPasswordHidden,
                keyboardType: TextInputType.visiblePassword,
                // Logic icon mắt thần
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordHidden 
                        ? Icons.visibility_off 
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                ),
              ),

              const SizedBox(height: 24),

              // --- LOGIN BUTTON ---
              ElevatedButton(
                onPressed: () {
                  // Xử lý đăng nhập
                  print("Email: ${_emailController.text}");
                  print("Pass: ${_passwordController.text}");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF77D0E), // Màu cam
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- FOOTER REGISTER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Điều hướng sang trang Register
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20), // Khoảng cách dưới cùng
            ],
          ),
        ),
      ),
    );
  }
}