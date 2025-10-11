import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:car_maintenance_system_new/core/providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      // Pass empty role - auth provider will auto-detect from Firestore
      final success = await ref.read(authProvider.notifier).signIn(
        _emailController.text.trim(),
        _passwordController.text,
        '', // Empty role triggers auto-detection in auth_provider
      );
      
      if (!success && mounted) {
        final errorMessage = ref.read(authProvider).error ?? 'Login failed. Please check your credentials.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      // If success, navigation is handled automatically by the router
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: keyboardHeight),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 1.sh - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),
                  
                  // Logo and Title
                  Column(
                    children: [
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Icon(
                          Icons.car_repair,
                          size: 50.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Car Maintenance',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontSize: 24.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Sign in to your account',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Login Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 14.sp),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(fontSize: 14.sp),
                            prefixIcon: Icon(Icons.email, size: 20.sp),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 16.h,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: TextStyle(fontSize: 14.sp),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: 14.sp),
                            prefixIcon: Icon(Icons.lock, size: 20.sp),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 16.h,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                size: 20.sp,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(
                          width: double.infinity,
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: authState.isLoading ? null : _handleLogin,
                            child: authState.isLoading
                                ? SizedBox(
                                    height: 20.w,
                                    width: 20.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.w,
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text('Sign In', style: TextStyle(fontSize: 16.sp)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Register Link
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.sp,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/register'),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
