import 'package:flutter/material.dart';

class Projects {
  final GlobalKey? keyController;
  final TextEditingController title;
  final TextEditingController description;

  Projects({
    this.keyController,
    required this.title,
    required this.description,
  });
}