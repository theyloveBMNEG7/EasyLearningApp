import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Optional: pretend to authenticate
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logging in...')),
      );

      // Navigate to student dashboard layout
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacementNamed(context, RoutePaths.studentDashboard);
      });
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/Books.jpeg'),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Welcome Back!!',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'OpenSans',
                  ),
                ),
                const SizedBox(height: 45),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: emailValidator,
                  onFieldSubmitted: (_) {
                    if (_formKey.currentState!.validate()) {
                      _handleLogin();
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'e.g. john.doe@gmail.com',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  validator: (value) => value != null && value.length >= 8
                      ? null
                      : 'Password must be 8+ characters',
                  onFieldSubmitted: (_) {
                    if (_formKey.currentState!.validate()) {
                      _handleLogin();
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: _togglePasswordVisibility,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Mulish-Medium'),
                  ),
                ),
                const SizedBox(height: 35),
                const Text(
                  'Or Login with',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => _handleSocialLogin('Facebook'),
                      icon: _buildSocialIconButton(
                          FontAwesomeIcons.facebookF, Colors.blue),
                      tooltip: 'Login with Facebook',
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () => _handleSocialLogin('Google'),
                      icon: _buildSocialIconButton(
                          FontAwesomeIcons.google, Colors.red),
                      tooltip: 'Login with Google',
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () => _handleSocialLogin('Apple'),
                      icon: _buildSocialIconButton(
                          FontAwesomeIcons.apple, Colors.black),
                      tooltip: 'Login with Apple',
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(color: Colors.blue, fontSize: 14),
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

  Widget _buildSocialIconButton(IconData icon, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}
