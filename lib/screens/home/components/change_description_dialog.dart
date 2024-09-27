
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/consts/constants.dart';

changeDescriptionDialog(context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Your CV does not match the job description. Please provide a relevant job description or update your CV accordingly.",style: kFont14Black),
            const SizedBox(height: 10),
            ElevatedButton(
                style: kElevatedButtonPrimaryBG,
                onPressed: () => Get.back(), child: const Text("Modify Description",style: kFont15White,))
          ],
        ),
      );
    },
  );
  ;
}
