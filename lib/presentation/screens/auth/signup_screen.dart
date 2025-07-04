import 'package:flutter/material.dart';
import '../../../core/constants/routes.dart';
import '../../../core/utils/validators.dart';
import '../../../services/auth_service.dart';
import '../../../data/models/user_model.dart';
import '../auth/signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _agreedToTerms = false;

  String? _selectedExam;
  String? _selectedSpeciality;
  String? _selectedOption;

  final Map<String, Map<String, List<String>>> examData = {
    "HND": {
      "Computer Engineering": ["Software Engineering", "Networking"],
      "Electrical Engineering": ["Power Systems", "Electronics"],
    },
    "BTS": {
      "Management": ["Accounting", "Marketing"],
      "Tourism": ["Hotel Management", "Travel Agency"],
    },
    "Other": {
      "General": ["Option A", "Option B"],
    },
  };

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _agreedToTerms) {
      if (_selectedExam == null ||
          _selectedSpeciality == null ||
          _selectedOption == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select exam, speciality and option')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final newUser = await _authService.registerStudent(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          examType: _selectedExam!,
          speciality: _selectedSpeciality!,
          option: _selectedOption!,
        );

        setState(() => _isLoading = false);

        if (newUser != null) {
          _showAccountCreatedPopup();
        }
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup error: ${e.toString()}')),
        );
      }
    } else if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept Terms & Conditions')),
      );
    }
  }

  void _showAccountCreatedPopup() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, color: Colors.green, size: 55),
            SizedBox(height: 20),
            Text('Account Created!'),
          ],
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, RoutePaths.signin);
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
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(
                  label: 'Full Name',
                  hintText: 'Enter your full name',
                  controller: _fullNameController,
                  icon: Icons.person,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 20),
                _buildEmailField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 20),
                _buildExamDropdown(),
                const SizedBox(height: 20),
                _buildSpecialityDropdown(),
                const SizedBox(height: 20),
                _buildOptionDropdown(),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Sign Up',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }

  Widget _buildEmailField() {
    return _buildTextField(
      controller: _emailController,
      label: 'Email',
      hintText: 'example@gmail.com',
      icon: Icons.email,
      validator: (v) {
        if (v == null || v.isEmpty) return 'Enter your email';
        if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(v)) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon:
              Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: _togglePasswordVisibility,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) {
        if (v == null || v.length < 6) return 'Password must be 6+ characters';
        return null;
      },
    );
  }

  Widget _buildExamDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedExam,
      decoration: InputDecoration(
        labelText: 'Select Exam',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: examData.keys
          .map((exam) => DropdownMenuItem(value: exam, child: Text(exam)))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedExam = value;
          _selectedSpeciality = null;
          _selectedOption = null;
        });
      },
      validator: (v) => v == null ? 'Please select an exam' : null,
    );
  }

  Widget _buildSpecialityDropdown() {
    if (_selectedExam == null) return const SizedBox();
    return DropdownButtonFormField<String>(
      value: _selectedSpeciality,
      decoration: InputDecoration(
        labelText: 'Select Speciality',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: examData[_selectedExam]!
          .keys
          .map((spec) => DropdownMenuItem(value: spec, child: Text(spec)))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedSpeciality = value;
          _selectedOption = null;
        });
      },
      validator: (v) => v == null ? 'Please select a speciality' : null,
    );
  }

  Widget _buildOptionDropdown() {
    if (_selectedSpeciality == null) return const SizedBox();
    return DropdownButtonFormField<String>(
      value: _selectedOption,
      decoration: InputDecoration(
        labelText: 'Select Option',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: examData[_selectedExam]![_selectedSpeciality]!
          .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
          .toList(),
      onChanged: (value) => setState(() => _selectedOption = value),
      validator: (v) => v == null ? 'Please select an option' : null,
    );
  }
}
