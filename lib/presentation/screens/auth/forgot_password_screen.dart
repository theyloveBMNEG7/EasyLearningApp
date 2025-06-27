import 'package:flutter/material.dart';
import 'signin_screen.dart';
import 'otp_verification_screen.dart';
import '../../../core/utils/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _showLoadingDialog();
    }
  }

  void _showLoadingDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.blue),
            SizedBox(height: 20),
            Text('Sending Verification Code...'),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context);
    _showSuccessDialog();
  }

  void _showSuccessDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, color: Colors.green, size: 55),
            SizedBox(height: 20),
            Text('Verification Code Sent! Check your email.'),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OTPVerificationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 80),
              const Text(
                'Forgot password?',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'OpenSans'),
              ),
              const SizedBox(height: 15),
              const Text(
                'A verification code will be send to your email.',
                style: TextStyle(color: Colors.black54, fontSize: 19),
              ),
              const SizedBox(height: 55),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: emailValidator,
                onFieldSubmitted: (_) {
                  if (_formKey.currentState!.validate()) {
                    _submit(); // ✅ Corrected method name
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'e.g. johndoe@gmail.com',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
              ),
              const SizedBox(height: 60),
              // Verify Button
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color.fromARGB(255, 0, 110, 201),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Verify',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'Mulish-Medium'),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Or',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 25),
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
                    "Remember Password? Sign In",
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
