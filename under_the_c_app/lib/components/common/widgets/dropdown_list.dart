import 'package:flutter/material.dart';
import 'package:under_the_c_app/components/events/event_create.dart';

class DropdownList extends StatefulWidget {
  const DropdownList({super.key, required this.droppedItems});

  final List<DropdownMenuItem<String>> droppedItems;

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
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
