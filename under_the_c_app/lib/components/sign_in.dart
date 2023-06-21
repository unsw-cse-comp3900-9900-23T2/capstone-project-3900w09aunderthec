import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.black,
          minimumSize: Size(250, 60),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)) // Background color
          ),
      onPressed: () {},
      child: const Text(
        'Sign In',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
