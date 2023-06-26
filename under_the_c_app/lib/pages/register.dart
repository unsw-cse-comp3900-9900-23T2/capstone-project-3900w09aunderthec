import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/io_client.dart';
import 'package:under_the_c_app/components/log_in_button.dart';

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

  int _userValue = 0;

  void incorrectRegisterMessage(error) {
    showDialog(
      context: context,
      builder: (context) {
        switch (error.code) {
          case 'invalid-email':
            return const AlertDialog(
              title: Text('Invalid Email'),
            );
          case 'email-already-in-use':
            return const AlertDialog(
              title: Text('Email has already been registered'),
            );
          case 'weak-password':
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
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    var ioClient = IOClient(client);

    final registerUrl =
        Uri.https('10.0.2.2:7161', '/Authentication/RegisterUser');

    try {
      // register the user to firebase
      final userCredentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // if successfully registered then let backend know
      if (userCredentials != null) {
        final response = await ioClient.post(
          registerUrl,
          headers: {
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Accept': '*/*'
          },
          body: jsonEncode({
            'Username': usernameController.text,
            'Email': emailController.text,
            'UserType': _userValue.toString()
          }),
        );

        // handle http response
        if (response.statusCode != 200) {
          throw Exception(
              'User created, failed to notify db. ${response.statusCode}');
        } else {
          // jsonDecode(response.body) for JSON payloads
          print('RECEIVED MESSAGE: ${response.body}');
        }
      }
    } on FirebaseAuthException catch (error) {
      incorrectRegisterMessage(error);
    } catch (e) {
      print('An error occured: $e');
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
              // logo
              const Icon(
                Icons.emoji_people,
                size: 80,
              ),

              const SizedBox(
                height: 20,
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                      value: 1,
                      groupValue: _userValue,
                      onChanged: (value) {
                        setState(() {
                          _userValue = value!;
                        });
                      }),
                  const Text('User'),
                  Radio(
                      value: 2,
                      groupValue: _userValue,
                      onChanged: (value) {
                        setState(() {
                          _userValue = value!;
                        });
                      }),
                  const Text('Host'),
                ],
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

              // Sign Up Button
              LogInButton(
                text: "Register",
                onTap: registerTheUser,
              ),

              const SizedBox(
                height: 100,
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
