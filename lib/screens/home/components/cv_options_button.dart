import 'package:flutter/material.dart';
import '../../../utils/consts/constants.dart';

Widget cvOptionButton({required String title, required VoidCallback onTap}) {
  return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
              backgroundColor: kBackgroundColor,
              shape: const RoundedRectangleBorder(
                  side: BorderSide(color: kPurple),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0), bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)))),
          child: Text(title, style: kFont10Black)));
}
