import 'package:flutter/material.dart';
import 'package:under_the_c_app/components/sign_in.dart';

import 'components/login_fields.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 215, 235, 255),
        body: SafeArea(
          child: Center(
            child: Column(
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
                  controller: usernameController,
                  hintText: 'Username',
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

                // Sign In Button
                const SignInButton(),
              ],
            ),
          ),
        ));
  }
}
