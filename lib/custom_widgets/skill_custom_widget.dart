import 'package:flutter/material.dart';
import 'custom_editable_text.dart';

class SkillCircullarWidget extends StatelessWidget {
  const SkillCircullarWidget({
    super.key,
    required this.skill,
    required this.onButtonTap,
    this.leftPadding = 10,
    this.isRemovable = true,
  });

  final TextEditingController skill;
  final double leftPadding;
  final VoidCallback onButtonTap;
  final bool isRemovable;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: leftPadding),
        Container(
          width: 3,
          height: 3,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0XFF2E2D2D),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: CustomEditableText(
            bottomMargin: 0,
            maxLength: 50,
            backgroundColor: const Color(0XFFe7e7fb),
            controller: skill,
            style: const TextStyle(
              color: Color(0XFF4E4949),
              fontSize: 8,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ),
        isRemovable
            ? GestureDetector(
          onTap: onButtonTap,
          child: const Icon(
            Icons.remove_circle_outline,
            size: 12,
            color: Color(0XFFFF5E59),
          ),
        )
            : const Icon(
          Icons.remove_circle_outline,
          size: 12,
          color: Colors.grey,
        ),
      ],
    );
  }
}
