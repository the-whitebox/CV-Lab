import 'package:flutter/material.dart';

class EducationHistory {
  final GlobalKey? keyController;

  final TextEditingController city;
  final TextEditingController country;
  final TextEditingController startDate;
  final TextEditingController endDate;
  final TextEditingController description;
  final TextEditingController instituteName;
  final TextEditingController fieldOfStudy;

  EducationHistory(
      {this.keyController,
      required this.city,
      required this.country,
      required this.startDate,
      required this.endDate,
      required this.description,
      required this.instituteName,
      required this.fieldOfStudy});
}
