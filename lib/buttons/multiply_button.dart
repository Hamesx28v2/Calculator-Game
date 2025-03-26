import 'package:flutter/material.dart';

class MultiplyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MultiplyButton({super.key, required this.onPressed});

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
      child: const Text(
        "x",
        style: TextStyle(fontSize: 24, color: Colors.green),
      ),
    );
  }
}
