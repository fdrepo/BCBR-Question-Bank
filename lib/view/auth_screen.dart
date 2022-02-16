import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'otp_screen.dart';

class AuthScreen extends HookWidget {
  const AuthScreen({Key? key}) : super(key: key);

  void _navigateToOtpSceen(BuildContext context, String phoneNumber) {
    Navigator.of(context).pushReplacement(OtpScreen.route(phoneNumber));
  }

  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  prefix: Text('+91'),
                  label: Text('Phone Number'),
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: () => _navigateToOtpSceen(
                  context,
                  textEditingController.text,
                ),
                child: const Text('Send OTP'),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size(double.infinity, 38),
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
