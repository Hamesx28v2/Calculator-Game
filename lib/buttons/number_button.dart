import 'package:flutter/material.dart';

class NumberButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const NumberButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 49, 48, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255)),
      ),
    );
  }
}
