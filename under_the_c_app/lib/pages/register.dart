import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/components/log_in_button.dart';
import 'package:http/http.dart' as http;

import '../components/login_fields.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void incorrectRegisterMessage(error) {
    showDialog(
      context: context,
      builder: (context) {
        switch (error.code) {
          case 'auth/invalid-email':
            return const AlertDialog(
              title: Text('Invalid Email'),
            );
          case 'auth/email-already-in-use':
            return const AlertDialog(
              title: Text('Email has already been registered'),
            );
          case 'auth/weak-password':
            return const AlertDialog(
              title: Text('Password too weak'),
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

  void registerTheUser() async {
    final registerUrl = Uri.parse('http:localhost');

    try {
      // register the user to firebase
      final userCredentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // if successfully registered then let backend know
      if (userCredentials != null) {
        final response = await http.post(
          registerUrl,
          body: {
            'Username': usernameController.text,
            'Email': emailController.text,
          },
        );

        // handle http response
        if (response.statusCode != 200) {
          print(
              'User created, failed to notify db. Code: ${response.statusCode}');
        }
      }
    } on FirebaseAuthException catch (error) {
      incorrectRegisterMessage(error);
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

              Login_Field(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),

              const SizedBox(
                height: 10,
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
                    Text(
                      'Reset Password',
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // Sign Up Button
              LogInButton(
                text: "Register",
                onTap: registerTheUser,
              ),

              const SizedBox(
                height: 200,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already Registered?'),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
