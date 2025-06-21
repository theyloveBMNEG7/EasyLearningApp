import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../LoginSreens/signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedExam;
  bool _obscurePassword = true;
  bool _agreedToTerms = false;

  void _handleSocialLogin(String platform) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Attempting to sign in with $platform...')),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _agreedToTerms) {
      _showSignupProgressPopup();
    } else if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to terms & conditions')),
      );
    }
  }

  void _showSignupProgressPopup() async {
    showDialog(
      context: context,
      barrierDismissible: false,
/*************  ✨ Windsurf Command ⭐  *************/
      /// Shows a popup indicating that an account has been created, waits for 2 seconds,
      /// then navigates to the LoginScreen.
/*******  b6974571-80ae-4670-8b89-6473d067b333  *******/ builder: (_) =>
          const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.blue),
            SizedBox(height: 20),
            Text('Creating Account...'),
          ],
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context);
    _showAccountCreatedPopup();
  }

  void _showAccountCreatedPopup() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green, size: 50),
            SizedBox(height: 20),
            Text('Account Created!'),
          ],
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SigninScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 25),
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/Books.jpeg'),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Create an account',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'OpenSans',
                  ),
                ),
                const SizedBox(height: 45),
                _buildTextField(
                  label: 'Full Name',
                  hintText: 'Enter your full name',
                  controller: _nameController,
                  icon: Icons.person,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 25),
                _buildDropdownField(),
                const SizedBox(height: 25),
                _buildTextField(
                  label: 'Email Address',
                  hintText: 'e.g. John.doe@gmail.com',
                  controller: _emailController,
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (!v.contains('@')) return 'Enter valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                _buildPasswordField(),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: (v) =>
                          setState(() => _agreedToTerms = v ?? false),
                    ),
                    const Expanded(
                      child: Text(
                        'I agree to the Terms & Conditions',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: const Color.fromARGB(255, 0, 110, 201),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'Mulish-Medium',
                    ),
                  ),
                ),
                const SizedBox(height: 45),
                const Text(
                  'Or Sign Up with',
                  style: TextStyle(color: Colors.black54),
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
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SigninScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Already have an account? Sign In',
                      style: TextStyle(color: Colors.blue),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      isDense: true,
      value: _selectedExam,
      decoration: InputDecoration(
        labelText: 'Select Your Exam',
        hintText: 'Choose one',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      items: ['HND', 'BTS', 'Other']
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => setState(() => _selectedExam = v),
      validator: (v) => v == null ? 'Please select an exam' : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      validator: (v) {
        if (v == null || v.length < 8) return 'Password must be 8+ chars';
        if (v.contains(' ')) return 'No spaces allowed';
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon:
              Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: _togglePasswordVisibility,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        helperText:
            'Minimum 8 characters. No spaces or special symbols allowed.',
        helperStyle: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildSocialIconButton(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}
