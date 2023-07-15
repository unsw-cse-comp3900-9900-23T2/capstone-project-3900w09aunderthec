import 'package:flutter/material.dart';

class DropdownList extends StatefulWidget {
  const DropdownList({
    super.key,
    required this.droppedItem,
    required this.initial,
    required this.onValueChanged,
  });

  final List<DropdownMenuItem<String>> droppedItem;
  final String initial;
  final ValueChanged<String> onValueChanged;

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
  String selectedValue = '';

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: selectedValue,
        items: widget.droppedItem,
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue!;
            widget.onValueChanged(selectedValue);
          });
        });
  }
}
