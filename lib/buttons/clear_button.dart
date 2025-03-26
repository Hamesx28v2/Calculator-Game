import 'package:flutter/material.dart';

class ClearButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ClearButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
      ),
      child: const Text(
        "C",
        style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255)),
      ),
    );
  }
}
