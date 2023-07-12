// import 'package:flutter/material.dart';

// class SwitchButton extends StatefulWidget {
//   const SwitchButton({super.key});

//   @override
//   State<SwitchButton> createState() => _SwitchButtonState();
// }

// class _SwitchButtonState extends State<SwitchButton> {
//   bool light0 = true;
//   bool light1 = true;

//   final MaterialStateProperty<Icon?> thumbIcon =
//       MaterialStateProperty.resolveWith<Icon?>(
//     (Set<MaterialState> states) {
//       if (states.contains(MaterialState.selected)) {
//         return const Icon(Icons.check);
//       }
//       return const Icon(Icons.close);
//     },
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Switch(
//       thumbIcon: thumbIcon,
//       value: light1,
//       onChanged: (bool value) {
//         setState(() {
//           light1 = value;
//         });
//       },
//     );
//   }
// }
