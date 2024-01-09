import 'package:flutter/material.dart';

class GenreSeparator extends StatelessWidget {
  const GenreSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.yellow.shade600,
      ),
    );
  }
}