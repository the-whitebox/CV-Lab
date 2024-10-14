import 'package:flutter/material.dart';
import '../../../utils/consts/constants.dart';

Widget chooseOptionTile() {
  return Stack(children: [
    Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                decoration: BoxDecoration(color: kLightPurple, borderRadius: BorderRadius.circular(12)),
                child: const Text('Do you want to choose a template now?', style: kFont10Black)))),
    Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Align(alignment: Alignment.topLeft, child: Image.asset('assets/images/avatars/dogDP.png', height: 30, width: 30)))
  ]);
}
