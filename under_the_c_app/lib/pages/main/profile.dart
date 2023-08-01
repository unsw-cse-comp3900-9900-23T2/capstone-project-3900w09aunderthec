import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes/routes.dart';
import 'package:under_the_c_app/config/session_variables.dart';

class ProfilePage extends StatefulWidget {
  final String imageUrl = ''; // replace with the actual URL

  const ProfilePage({Key? key})
      : super(key: key); // replace with the actual points

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> vip_level = [
    'images/profile/Vip_level_1.png',
    'images/profile/Vip_level_2.png',
    'images/profile/Vip_level_3.png',
    'images/profile/Vip_level_4.png'
  ];
  final levelBarKey = GlobalKey<LevelBarState>();

  int frameUpgrade() {
    int index = 0;
    switch (sessionVariables.vipLevel) {
      case >= 20:
        index = 3;
        break;
      case >= 15:
        index = 2;
        break;
      case >= 10:
        index = 1;
        break;
      default:
        index = 0;
    }
    return index;
  }

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
            alignment: AlignmentDirectional.center,
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                vip_level[frameUpgrade()],
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: MediaQuery.of(context).size.width * 0.078,
                left: MediaQuery.of(context).size.width * 0.167,
                child: CircleAvatar(
                  backgroundImage: const AssetImage('images/users/guy.jpg'),
                  radius: MediaQuery.of(context).size.width * 0.188,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: MediaQuery.of(context).size.width * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/profile/vip.png'),
                Text(
                  'VIP ${sessionVariables.vipLevel}',
                  // 'VIP ${index + 1}',
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
            'Loyal Points: ${sessionVariables.loyaltyPoints}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          LevelBar(
              key: levelBarKey,
              progress: (sessionVariables.loyaltyPoints % 1000)),
          const SizedBox(height: 20),
          !sessionVariables.sessionIsHost
              ? ElevatedButton(
                  onPressed: () {
                    context.go(
                        AppRoutes.viewBooking(sessionVariables.uid.toString()));
                  },
                  child: const Text('View Booking'),
                )
              : Container(),
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

class LevelBar extends StatefulWidget {
  const LevelBar({super.key, required this.progress});
  final int progress;

  @override
  State<StatefulWidget> createState() {
    return LevelBarState();
  }
}

class LevelBarState extends State<LevelBar> {
  double progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    progressValue = widget.progress.toDouble() / 10;
  }

  @override
  Widget build(BuildContext context) {
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
                value: progressValue / 100,
              ),
              Text('${(progressValue).round()}%'),
            ],
          )),
    );
  }
}
