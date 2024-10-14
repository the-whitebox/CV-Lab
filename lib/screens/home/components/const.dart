import 'package:flutter/material.dart';
import '../../../utils/consts/constants.dart';

InputDecoration descriptionFieldDecoration(bool checkError) {
  return InputDecoration(
      enabledBorder: customBorderHome,
      focusedBorder: customBorderHome,
      errorBorder: customBorderHome,
      focusedErrorBorder: customBorderHome,
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      hintText: 'Enter job description',
      hintStyle: kFadedText.copyWith(fontSize: 14),
      errorStyle: const TextStyle(fontSize: 10, color: kErrorColor),
      errorText: checkError ? 'Job description can\'t be empty' : null);
}

TextStyle purpleUnderlineButton =
    kFont12.copyWith(color: kPurple, decoration: TextDecoration.underline, decorationColor: kPurple, decorationThickness: 2.0);
