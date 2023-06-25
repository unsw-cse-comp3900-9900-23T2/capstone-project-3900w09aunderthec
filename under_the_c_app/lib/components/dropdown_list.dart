import 'package:flutter/material.dart';

import 'create_event.dart';

class DropdownList extends StatefulWidget {
  const DropdownList({super.key, required this.droppedItems});

  final List<DropdownMenuItem<String>> droppedItems;
  // final String initial
  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  /*
  if initial != Null {
    String selectedValue = initial;
  }
  else 
  */
  String selectedValue = "Other";

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: selectedValue,
        items: droppedItems,
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue!;
          });
        });
  }
}
