import 'package:flutter/material.dart';

import 'custom_editable_text.dart';

class ReferenceWidget extends StatelessWidget {
  const ReferenceWidget({
    super.key,
    required this.personName,
    required this.contactNumber,
    required this.referenceText,
    required this.onRemoveTap,
  });

  final TextEditingController personName;
  final TextEditingController contactNumber;
  final TextEditingController referenceText;
  final VoidCallback onRemoveTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomEditableText(
              horizontalPadding: 0,
              rightMargin: 0,
              controller: personName,
              style: const TextStyle(
                color: Color(0XFF4E4949),
                fontSize: 8,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: onRemoveTap,
                child: const Icon(
                  Icons.remove_circle_outline,
                  size: 12,
                  color: Color(0XFFFF5E59),
                ),
              ),
            ),
          ],
        ),
        CustomEditableText(
          horizontalPadding: 0,
          rightMargin: 0,
          controller: contactNumber,
          style: const TextStyle(
            color: Color(0XFF4E4949),
            fontSize: 8,
            fontFamily: 'Inter',
          ),
        ),
        CustomEditableText(
          horizontalPadding: 0,
          rightMargin: 0,
          controller: referenceText,
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
