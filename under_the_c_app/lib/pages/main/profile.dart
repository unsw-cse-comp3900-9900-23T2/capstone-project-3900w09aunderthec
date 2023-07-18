import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes/routes.dart';
import 'package:under_the_c_app/config/session_variables.dart';

class ProfilePage extends StatefulWidget {
  final String imageUrl = ''; // replace with the actual URL
  final int loyalPoints = 0;

  const ProfilePage({Key? key})
      : super(key: key); // replace with the actual points

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
            'Loyal Points: ${widget.loyalPoints}',
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context
                  .go(AppRoutes.viewBooking(sessionVariables.uid.toString()));
            },
            child: const Text('View Booking'),
          ),
        ],
      ),
    );
  }
}
