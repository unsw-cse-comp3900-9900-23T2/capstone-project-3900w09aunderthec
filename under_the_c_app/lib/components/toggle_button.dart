import 'package:flutter/material.dart';

const List<Widget> eventTypes = <Widget>[
  Text('Private'),
  Text('Public'),
];

class ToggleButton extends StatefulWidget {
  // const ToggleButton({super.key});
  // final bool privacy
  final Function(List<bool>) onSelectionChanged;
  const ToggleButton({Key? key, required this.onSelectionChanged})
      : super(key: key);

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  /* 
  if privacy
    final List<bool> _selectedEventTypes = <bool>[true, false];
  else
  */
  final List<bool> _selectedEventTypes = <bool>[true, false];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 5),
            ToggleButtons(
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _selectedEventTypes.length; i++) {
                    _selectedEventTypes[i] = i == index;
                  }
                });
                widget.onSelectionChanged(_selectedEventTypes);
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.red[700],
              selectedColor: Colors.white,
              fillColor: Colors.red[200],
              color: Colors.red[400],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 80.0,
              ),
              isSelected: _selectedEventTypes,
              children: eventTypes,
            ),
          ],
        ),
      ),
    );
  }
}
