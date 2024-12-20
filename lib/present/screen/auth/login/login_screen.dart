import 'package:flutter/material.dart';
import 'package:portal_hotel/data/live/auth_provider.dart';
import 'package:portal_hotel/data/local_storage/local_storage.dart';
import 'package:portal_hotel/data/response/error_response.dart';
import 'package:portal_hotel/network/services/api_endpoints.dart';
import 'package:portal_hotel/network/services/api_service.dart';
import 'package:portal_hotel/present/screen/import_data/controllers/import_data_controller.dart';
import 'package:portal_hotel/present/screen/main_screen.dart';
import 'package:portal_hotel/present/widget/loading_widget.dart';
import 'package:portal_hotel/res/images.dart';
import 'package:portal_hotel/utils/commons.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _isLoading = false; // Biến để quản lý trạng thái loading
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  // Hàm login
  void _login() async {
    setState(() {
      _isLoading = true; // Bắt đầu loading khi bắt đầu gọi API
    });

    try {
      // final response = await _apiService.post(
      //   PortalApi.login,
      //   {
      //     'UserName': _emailController.text,
      //     'PassWord': _passwordController.text,
      //   },
      // );
      // final fullName = response['FullName'] ?? "";
      // final acm = response['ACM'] ?? "";
      // final local = response['Local'] ?? "";
      // final fnb = response['FNB'] ?? "";
      // final List<String> permission = (response['Roles'] ?? []).cast<String>();
      // saveUsername(_emailController.text);
      // savePassword(_passwordController.text);
      //
      // Provider.of<AuthProvider>(context, listen: false)
      //     .login(fullName, acm, local, fnb);
      Provider.of<AuthProvider>(context, listen: false)
          .login('fullName', 'acm', 'local', 'fnb');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ImportDataController()),
            ],
            child: const MainScreen(),
          ),
        ),
      );
    } catch (e) {
      deleteUsername();
      deletePassword();
      if (e is ErrorResponse) {
        showFlushbarMessage(
          context: context,
          message: 'Thông tin tài khoản không chính xác',
        );
      } else {
        showFlushbarMessage(context: context, message: e.toString());
      }
    } finally {
      setState(() {
        _isLoading = false; // Tắt loading khi quá trình gọi API hoàn tất
      });
    }
  }

  @override
  void initState() {
    _emailController.text = loadUsername();
    _passwordController.text = loadPassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00BFFF),Color(0xFF003366),],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                width: screenWidth > 600 ? 400 : double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    ClipOval(
                      child: Image.asset(
                        NSGImages.logoLogin,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Vui lòng đăng nhập tài khoản của bạn',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 20),

                    // Email TextField
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Tài khoản',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password TextField
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      onSubmitted: (inputText) {
                        if (_emailController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty) {
                          _login();
                        } else {
                          showFlushbarMessage(
                            context: context,
                            message: 'Vui lòng nhập thông tin tài khoản.',
                          );
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText; // Thay đổi trạng thái ẩn/hiện
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            _login();
                          } else {
                            showFlushbarMessage(
                              context: context,
                              message: 'Vui lòng nhập thông tin tài khoản.',
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Đăng nhập',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading) // Hiển thị màn hình loading khi trạng thái isLoading là true
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: NLLoadingWidget(), // Widget loading của bạn
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
