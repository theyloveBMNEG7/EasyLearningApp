import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'new_password_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _showOtpError = false;

  void _verifyOTP() {
    setState(() {
      _showOtpError = _otpController.text.length != 6;
    });

    if (!_showOtpError) {
      _showLoadingPopup();
    }
  }

  void _showLoadingPopup() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.blue),
            SizedBox(height: 16),
            Text('Verifying OTP...'),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context); // Close loading popup

    // Proceed to Reset Password screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const NewPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 206, 207, 209),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.blue),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Text(
              'OTP Verification',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'OpenSans'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter the 6-digit code sent to your email',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'OpenSans',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Pinput for OTP
            Pinput(
              controller: _otpController,
              length: 6,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              showCursor: true,
              keyboardType: TextInputType.number,
              onCompleted: (pin) => _verifyOTP(),
            ),

            const SizedBox(height: 10),

            // Red Helper Text Below the OTP Boxes
            if (_showOtpError)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please enter the 6-digit OTP',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.redAccent,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

            const SizedBox(height: 60),

            ElevatedButton(
              onPressed: _verifyOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 110, 201),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Verify',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),

            const SizedBox(height: 35),

            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Resending OTP...')),
                );
              },
              child: const Text(
                "Didn't receive code? Resend",
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
