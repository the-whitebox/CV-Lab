import 'package:flutter/material.dart';

class EmploymentHistory {
  final GlobalKey? keyController;
  final TextEditingController companyName;
  final TextEditingController jobTitle;
  final TextEditingController city;
  final TextEditingController country;
  final TextEditingController startDate;
  final TextEditingController endDate;
  final TextEditingController description;

  EmploymentHistory({
    this.keyController,
    required this.companyName,
    required this.jobTitle,
    required this.city,
    required this.country,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

}