import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/validators.dart';
import '../../../core/constants/routes.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate authentication delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Save login status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Navigate to dashboard
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, RoutePaths.studentDashboard);
    }
  }

  void _handleSocialLogin(String platform) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Attempting to sign in with $platform...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 42,
                  backgroundImage: AssetImage('assets/images/Books.jpeg'),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: emailValidator,
                  decoration: _inputDecoration('Email', Icons.email),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  validator: (value) => value != null && value.length >= 8
                      ? null
                      : 'Password must be at least 8 characters',
                  decoration: _inputDecoration(
                    'Password',
                    Icons.lock,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: 'Mulish-Medium',
                          ),
                        ),
                      ),
                const SizedBox(height: 30),
                const Text(
                  'Or login with',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton(FontAwesomeIcons.facebookF, Colors.blue,
                        () => _handleSocialLogin('Facebook')),
                    const SizedBox(width: 20),
                    _socialButton(FontAwesomeIcons.google, Colors.red,
                        () => _handleSocialLogin('Google')),
                    const SizedBox(width: 20),
                    _socialButton(FontAwesomeIcons.apple, Colors.black,
                        () => _handleSocialLogin('Apple')),
                  ],
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon,
      {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  Widget _socialButton(IconData icon, Color color, VoidCallback onPressed) {
    return Ink(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
