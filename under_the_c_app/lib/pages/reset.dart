import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/log_in_button.dart';
import '../components/login_fields.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final emailController = TextEditingController();

  void incorrectResetMessage(error) {
    showDialog(
      context: context,
      builder: (context) {
        switch (error.code) {
          case 'invalid-email':
            return const AlertDialog(
              title: Text('Invalid Email'),
            );
          case 'user-not-found':
            return const AlertDialog(
              title: Text("You haven't registered yet"),
            );
          default:
            // Handle other errors
            return const AlertDialog(
              title: Text('Error Occurred, Try Again'),
            );
        }
      },
    );
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
              content: Text('Password reset link sent! Check your inbox'));
        },
      );
    } on FirebaseAuthException catch (e) {
      incorrectResetMessage(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 175, 198, 221),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),

              // logo
              const Icon(
                Icons.lock_reset,
                size: 100,
              ),

              const SizedBox(
                height: 50,
              ),

              // welcome message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'Enter your email to receive a reset password link',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700], fontSize: 18),
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // Username Text Field
              Login_Field(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(
                height: 25,
              ),

              // Sign In Button
              LogInButton(
                text: "Reset Password",
                onTap: resetPassword,
              ),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.,
                  children: [
                    const Text('Remembered Your Password?'),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go('/');
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
