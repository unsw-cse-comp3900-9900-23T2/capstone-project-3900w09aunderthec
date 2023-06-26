import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/components/log_in_button.dart';

import '../components/login_fields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void incorrectLoginMessage(error) {
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
              title: Text('Unregistered Account, Please Register'),
            );
          case 'wrong-password':
            return const AlertDialog(
              title: Text('Incorrect Password, Please Retry'),
            );
          default:
            // Handle other errors
            return const AlertDialog(
              title: Text('Error Occurred, Try Restarting'),
            );
        }
      },
    );
  }

  void signUserIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (error) {
      incorrectLoginMessage(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 215, 235, 255),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),

              // logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(
                height: 50,
              ),

              // welcome message
              Text(
                'Find your dream event!',
                style: TextStyle(color: Colors.grey[700], fontSize: 20),
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
                height: 10,
              ),

              // Password Text Field
              Login_Field(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.go('/reset');
                      },
                      child: Text(
                        'Reset Password',
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // Sign In Button
              LogInButton(
                text: "Sign In",
                onTap: signUserIn,
              ),

              const SizedBox(
                height: 10,
              ),

              // Sign In Button
              LogInButton(
                text: "Guests",
                onTap: () {
                  context.go('/guest');
                },
              ),

              const SizedBox(
                height: 100,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not registered yet?'),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go('/register');
                    },
                    child: const Text(
                      'Register Now',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
