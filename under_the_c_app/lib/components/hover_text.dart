import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// https://stackoverflow.com/questions/73770245/how-to-hover-text-in-flutter

class HoverTextBuilder extends StatefulWidget {
  const HoverTextBuilder({
    required this.builder,
    Key? key,
  }) : super(key: key);

  final Widget Function(bool isHovered) builder;

  @override
  State<HoverTextBuilder> createState() => _HoverBuilderTextState();
}

class _HoverBuilderTextState extends State<HoverTextBuilder> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEnterEvent event) => _onHoverChanged(enabled: true),
      onExit: (PointerExitEvent event) => _onHoverChanged(enabled: false),
      child: widget.builder(_isHovered),
    );
  }

  void _onHoverChanged({required bool enabled}) {
    setState(() {
      _isHovered = enabled;
    });
  }
}
