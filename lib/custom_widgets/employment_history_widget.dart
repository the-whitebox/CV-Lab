import 'package:flutter/material.dart';

import 'custom_editable_text.dart';

class EmploymentHistoryWidget extends StatelessWidget {
  final TextEditingController title;
  final TextEditingController from;
  final TextEditingController till;
  final TextEditingController description;
  final TextEditingController city;
  final TextEditingController country;
  final TextEditingController companyName;
  final double titleFontSize;
  final double durationFontSize;
  final Color backgroundColor;
  final VoidCallback onRemoveTap;
  final bool isRemovable;

  const EmploymentHistoryWidget({
    super.key,
    required this.title,
    required this.from,
    required this.till,
    required this.description,
    this.titleFontSize = 8,
    this.durationFontSize = 6,
    this.backgroundColor = Colors.white,
    required this.onRemoveTap,
    required this.city,
    required this.country,
    required this.companyName,
    this.isRemovable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    CustomEditableText(
                      horizontalPadding: 0,
                      rightMargin: 0,
                      backgroundColor: backgroundColor,
                      controller: title,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: const Color(0xFF4E4949),
                        fontSize: titleFontSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      " at ",
                      style: TextStyle(
                        color: const Color(0xFF4E4949),
                        fontSize: titleFontSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CustomEditableText(
                      horizontalPadding: 0,
                      rightMargin: 0,
                      backgroundColor: backgroundColor,
                      controller: companyName,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: const Color(0xFF4E4949),
                        fontSize: titleFontSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      ", ",
                      style: TextStyle(
                        color: const Color(0xFF4E4949),
                        fontSize: titleFontSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CustomEditableText(
                      horizontalPadding: 0,
                      rightMargin: 0,
                      backgroundColor: backgroundColor,
                      controller: city,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: const Color(0xFF4E4949),
                        fontSize: titleFontSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      ", ",
                      style: TextStyle(
                        color: const Color(0xFF4E4949),
                        fontSize: titleFontSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CustomEditableText(
                      horizontalPadding: 0,
                      rightMargin: 0,
                      backgroundColor: backgroundColor,
                      controller: country,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: const Color(0xFF4E4949),
                        fontSize: titleFontSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              isRemovable
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
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
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.remove_circle_outline,
                  size: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: CustomEditableText(
                  backgroundColor: backgroundColor,
                  controller: from,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: const Color(0xFF4E4949),
                    fontSize: durationFontSize,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Text(
                    '_',
                    style: TextStyle(
                      color: const Color(0xFF4E4949),
                      fontSize: durationFontSize,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  )),
              Expanded(
                flex: 6,
                child: CustomEditableText(
                  backgroundColor: backgroundColor,
                  controller: till,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: const Color(0xFF4E4949),
                    fontSize: durationFontSize,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Expanded(flex: 10, child: SizedBox())
            ],
          ),
          CustomEditableText(
            backgroundColor: backgroundColor,
            controller: description,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Color(0xFF4E4949),
              fontSize: 7,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
