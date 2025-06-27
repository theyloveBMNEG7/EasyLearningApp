import 'package:flutter/material.dart';
import 'signin_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _confirmFocusNode = FocusNode(); // for shifting focus
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _showLoadingDialog();
    }
  }

  void _toggleNewPassword() {
    setState(() {
      _obscureNew = !_obscureNew;
    });
  }

  void _toggleConfirmPassword() {
    setState(() {
      _obscureConfirm = !_obscureConfirm;
    });
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
            Text('Saving New Password...'),
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
            Text('New Password Saved!!'),
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
  void dispose() {
    _confirmFocusNode.dispose(); // Cleanup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 70),
                const Text(
                  "Enter New Password",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'OpenSans'),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Enter a new password for your account below. Make sure it’s secure and easy to remember..',
                  style: TextStyle(color: Colors.black54, fontSize: 20),
                ),
                const SizedBox(height: 55),

                // New Password
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNew,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_confirmFocusNode);
                  },
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureNew
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: _toggleNewPassword,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),

                const SizedBox(height: 20),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmFocusNode,
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirm
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: _toggleConfirmPassword,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),

                const SizedBox(height: 60),

                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Mulish-Medium'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
