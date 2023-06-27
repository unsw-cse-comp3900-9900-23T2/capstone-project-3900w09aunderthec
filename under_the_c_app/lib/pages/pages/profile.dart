import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  final String imageUrl = ''; // replace with the actual URL
  final int loyalPoints = 123;

  const ProfilePage({super.key}); // replace with the actual points

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('images/users/guy.jpg'),
            radius: 70,
          ),
          const SizedBox(height: 20),
          Text(
            'Loyal Points: $loyalPoints',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.go('/reset');
            },
            child: const Text('Reset Password'),
          ),
        ],
      ),
    );
  }
}
