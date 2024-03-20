import 'package:flutter/material.dart';
import 'custom_editable_text.dart';

class ProjectWidget extends StatelessWidget {
  const ProjectWidget({
    super.key,
    required this.title,
    required this.description,
    required this.onRemoveTap,
    this.isRemovable = true,
  });

  final TextEditingController title;
  final TextEditingController description;
  final VoidCallback onRemoveTap;
  final bool isRemovable;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child:  CustomEditableText(
              horizontalPadding: 0,
              rightMargin: 0,
              controller: title,
              style: const TextStyle(
                color: Color(0XFF4E4949),
                fontSize: 8,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),),
            isRemovable
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: onRemoveTap,
                child: const Icon(
                  Icons.remove_circle_outline,
                  size: 12,
                  color: Color(0XFFFF5E59),
                ),
              ),
            )
                : const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.remove_circle_outline,
                size: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        CustomEditableText(
          horizontalPadding: 0,
          rightMargin: 0,
          controller: description,
          style: const TextStyle(
            color: Color(0XFF4E4949),
            fontSize: 7,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
