import 'package:flutter/material.dart';

class EqualButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EqualButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
      ),
      child: const Text(
        "=",
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}
