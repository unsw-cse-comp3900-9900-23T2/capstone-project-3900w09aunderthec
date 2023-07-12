// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Login_Field extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  const Login_Field({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
          fillColor: Color.fromARGB(255, 240, 248, 255),
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Color.fromARGB(172, 85, 108, 152)),
        ),
      ),
    );
  }
}
