import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'signin_screen.dart';
import '../../../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedExam;
  String? _selectedSpeciality;
  String? _selectedOption;

  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  final _authService = AuthService();

  final Map<String, Map<String, List<String>>> examData = {
    "HND": {
      "Computer Engineering": [
        "Computer Hardware Engineering",
        "Networking & Telecommunications",
        "Systems Security & Cybersecurity",
      ],
      "Computer Science": [
        "Software Engineering",
        "Database Management",
        "Web Development & E-Commerce",
      ],
    },
    "BTS": {
      "Comptabilité et Gestion": [
        "Gestion Financière",
        "Audit et Contrôle de Gestion",
        "Fiscalité",
      ],
      "Management Commercial": [
        "Marketing Digital",
        "Négociation et Relation Client",
        "Commerce International",
      ],
    },
  };

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
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'OpenSans',
                  ),
                ),
                const SizedBox(height: 45),
                _buildTextField(
                  label: 'Full Name',
                  hintText: 'Enter your full name',
                  controller: _fullNameController,
                  icon: Icons.person,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 25),
                DropdownButtonFormField<String>(
                  isDense: true,
                  value: _selectedExam,
                  decoration: InputDecoration(
                    labelText: 'Select Your Exam',
                    hintText: 'Choose one',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  items: ['HND', 'BTS', 'Other']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() {
                    _selectedExam = v;
                    _selectedSpeciality = null;
                    _selectedOption = null;
                  }),
                  validator: (v) => v == null ? 'Please select an exam' : null,
                ),
                const SizedBox(height: 25),
                if (_selectedExam != null &&
                    examData.containsKey(_selectedExam))
                  DropdownButtonFormField<String>(
                    isDense: true,
                    value: _selectedSpeciality,
                    decoration: InputDecoration(
                      labelText: 'Select Speciality',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                    ),
                    items: examData[_selectedExam]!
                        .keys
                        .map((spec) =>
                            DropdownMenuItem(value: spec, child: Text(spec)))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedSpeciality = val;
                        _selectedOption = null;
                      });
                    },
                    validator: (v) =>
                        v == null ? 'Please select a speciality' : null,
                  ),
                if (_selectedExam != null && _selectedSpeciality != null)
                  const SizedBox(height: 25),
                if (_selectedSpeciality != null &&
                    _selectedExam != null &&
                    examData[_selectedExam]!.containsKey(_selectedSpeciality))
                  DropdownButtonFormField<String>(
                    isDense: true,
                    value: _selectedOption,
                    decoration: InputDecoration(
                      labelText: 'Select Option',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                    ),
                    items: examData[_selectedExam]![_selectedSpeciality]!
                        .map((option) => DropdownMenuItem(
                            value: option, child: Text(option)))
                        .toList(),
                    onChanged: (val) {
                      setState(() => _selectedOption = val);
                    },
                    validator: (v) =>
                        v == null ? 'Please select an option' : null,
                  ),
                const SizedBox(height: 25),
                _buildTextField(
                    label: 'Email Address',
                    hintText: 'e.g. John.doe@gmail.com',
                    controller: _emailController,
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }

                      final email = value.trim().toLowerCase();

                      // Basic email pattern with common domains
                      final basicPattern =
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|net|org|edu|gov|mil|io|co|cm|info)$";
                      final regex = RegExp(basicPattern);

                      // Block common problematic prefixes or banned terms
                      final blockedPatterns = [
                        RegExp(r'^sa@'),
                        RegExp(r'^admin@'),
                        RegExp(r'^test@'),
                        RegExp(r'^example@'),
                        RegExp(r'^noreply@'),
                        RegExp(r'^null@'),
                        RegExp(r'^invalid@'),
                      ];

                      // Allowlist specific domains (optional, for strict control)
                      final allowedDomains = [
                        'gmail.com',
                        'yahoo.com',
                        'outlook.com',
                        'student.edu.cm'
                      ];

                      if (!regex.hasMatch(email)) {
                        return 'Enter a valid email address';
                      }

                      if (blockedPatterns
                          .any((pattern) => pattern.hasMatch(email))) {
                        return 'This email address is not allowed';
                      }

                      // Optional strict domain filtering
                      final domain = email.split('@').last;
                      if (!allowedDomains.contains(domain)) {
                        return 'Only emails from approved domains are allowed';
                      }

                      return null;
                    }),
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
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 0, 110, 201),
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
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
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

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) {
        if (_formKey.currentState!.validate() && _agreedToTerms) {
          _submitForm();
        }
      },
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
