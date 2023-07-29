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
          // const CircleAvatar(
          //   backgroundImage: AssetImage('images/users/guy.jpg'),
          //   radius: 70,
          // ),
          // const SizedBox(height: 20),
          Stack(
            children: [
              Image.asset(
                'images/profile/Vip_level_4.png',
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: MediaQuery.of(context).size.width * 0.07,
                left: MediaQuery.of(context).size.width * 0.065,
                child: CircleAvatar(
                  backgroundImage: const AssetImage('images/users/guy.jpg'),
                  radius: MediaQuery.of(context).size.width * 0.19,
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.width * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/profile/vip.png'),
                Text(
                  'VIP 1',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
          LevelBar(progress: widget.loyalPoints),
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

class LevelBar extends StatefulWidget {
  const LevelBar({super.key, required this.progress});
  final int progress;

  @override
  State<StatefulWidget> createState() {
    return LevelBarState();
  }
}

class LevelBarState extends State<LevelBar> {
  @override
  Widget build(BuildContext context) {
    double progressValue = widget.progress.toDouble();
    return Center(
      child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LinearProgressIndicator(
                minHeight: MediaQuery.of(context).size.width * 0.05,
                backgroundColor: Colors.cyanAccent,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                value: progressValue,
              ),
              Text('${(progressValue * 100).round()}%'),
            ],
          )),
    );
  }
}
