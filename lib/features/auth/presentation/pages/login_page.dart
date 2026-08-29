import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // kDebugMode 사용을 위한 import
import 'package:flutter/material.dart';
import 'package:ui/core/api/api_client.dart';
import 'package:ui/core/services/token_service.dart';
import 'package:ui/features/note/presentation/pages/main_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form 유검효성 검증 및 입력제어 컨트롤러 선언
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 테스트용 정보
    if (kDebugMode) {
      _usernameController.text = 'testUser@test.go.kr';
      _passwordController.text = 'testUser';
    }
  }

  // 비밀번호 활성화 토글
  bool _isPasswordVisible = true;

  // 로그인 통신 중일 때 로딩 동글이(스피너)를 띄우기 위한 변수
  bool _isLoading = false;

  // 로그인 버튼 실행 시 비동기 함수
  Future<void> _handleLogin() async {
    // 입력값 검증
    // 빈값이면 리턴
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // 로딩 스피너 재생
    setState(() {
      _isLoading = true;
    });

    try {
      // Dio 통신
      final dio = ApiClient.instance;
      // 로그인정보 Post요청
      final response = await dio.post(
        '/users/login',
        data: {
          'email': _usernameController.text.trim(),
          'password': _passwordController.text.trim(),
        },
        // OAuth2 데이터
        // options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      // 성공 응답
      final accessToken = response.data['access_token'] as String;
      // 토큰 저장
      await TokenService.instance.saveTokens(accessToken: accessToken);
      // 성공메시지
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login successful!')));
      }

      // 메인화면 이동 후 로그인화면 스택제거
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false, // 로그인 화면 리턴 제거
      );
    } on DioException catch (e) {
      // 에러메시지
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    } finally {
      // 로딩 스피너 종료
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    // 화면 종료 후 메모리 누수를위해 컨트롤러 파기
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 64,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // 이메일 input field
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).nextFocus(); // 다음 입력 필드로 포커스 이동
                      },
                    ),
                    const SizedBox(height: 16),

                    // 비밀번호 input field
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: _isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        if (_formKey.currentState!.validate()) {
                          _handleLogin();
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // 로그인 버튼
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  _handleLogin();
                                }
                              },
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
