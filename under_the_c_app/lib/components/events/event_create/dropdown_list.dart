import 'package:flutter/material.dart';

class DropdownList extends StatefulWidget {
  const DropdownList({
    super.key,
    required this.droppedItem,
    required this.onValueChanged,
    this.initial,
  });

  final List<String> droppedItem;
  final ValueChanged<String> onValueChanged;
  final String? initial;

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selectedValue,
      items: widget.droppedItem
          .map((String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue!;
          widget.onValueChanged(selectedValue!);
        });
      },
    );
  }
}
