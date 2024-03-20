import 'package:flutter/material.dart';

class CvAddButton extends StatelessWidget {
  const CvAddButton({super.key, required this.onTap, this.buttonText = "Add"});

  final VoidCallback onTap;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 4),
        child: Row(
          children: [
            Text(
                buttonText,
                style: const TextStyle(
                  color: Color(0XFFC6A4FF),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(width: 5),
            const Icon(
              Icons.add_circle_outline,
              color: Color(0XFFC6A4FF),
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}
