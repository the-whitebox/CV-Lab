import 'package:flutter/material.dart';

class References {
  final GlobalKey? keyController;
  final TextEditingController personName;
  final TextEditingController contactNumber;
  final TextEditingController referenceText;

  References({
    this.keyController,
    required this.personName,
    required this.contactNumber,
    required this.referenceText,
  });
}