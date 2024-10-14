import 'package:flutter/material.dart';
import '../../../utils/consts/const_images.dart';
import '../../../utils/consts/constants.dart';

Widget featureHeader(screenWidth) {
  return Center(
      child: Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      featureCard(
          screenWidth: screenWidth,
          image: AppImages.homeUpload,
          title: "Upload",
          description: 'Upload your current CV or used a saved one.',
          color: kPurple),
      featureCard(
          screenWidth: screenWidth,
          image: AppImages.job,
          title: 'Job description',
          description: 'Copy and paste the job description',
          color: kBlackColor)
    ]),
    Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      featureCard(
          screenWidth: screenWidth,
          image: AppImages.template,
          title: 'Choose template',
          description: 'Review your new CV and choose a template',
          color: kHighlightedColor),
      featureCard(
          screenWidth: screenWidth,
          image: AppImages.downloadHome,
          title: 'Download',
          description: 'Now you can save or download it!',
          color: kBlue)
    ])
  ]));
}

Widget featureCard({
  required double screenWidth,
  required String image,
  required String title,
  required String description,
  required Color color,
}) {
  return SizedBox(
      width: screenWidth * 0.47,
      child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          color: kBackgroundColor,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Image.asset(image, width: 25, height: 25), Text(title, style: kFont13black500.copyWith(color: color))]),
                Row(
                  children: [
                    Expanded(child: Text(description, style: kFont11Black)),
                  ],
                )
              ]))));
}
