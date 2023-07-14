// List for Tags
import 'package:flutter/material.dart';

List<DropdownMenuItem<String>> get droppedItems {
  List<DropdownMenuItem<String>> eventType = [
    const DropdownMenuItem(
      value: "Arts",
      child: Text("Arts"),
    ),
    const DropdownMenuItem(
      value: "Business",
      child: Text("Business"),
    ),
    const DropdownMenuItem(
      value: "Comedy",
      child: Text("Comedy"),
    ),
    const DropdownMenuItem(
      value: "Food & Drink",
      child: Text("Food & Drink"),
    ),
    const DropdownMenuItem(
      value: "Fashion",
      child: Text("Fashion"),
    ),
    const DropdownMenuItem(
      value: "Music",
      child: Text("Music"),
    ),
    const DropdownMenuItem(
      value: "Sports",
      child: Text("Sports"),
    ),
    const DropdownMenuItem(
      value: "Science",
      child: Text("Science"),
    ),
    const DropdownMenuItem(
      value: "Other",
      child: Text("Other"),
    ),
  ];
  return eventType;
}
