import 'package:flutter/material.dart';

enum Department { finance, law, it, medical }

const Map<Department, String> departmentNames = {
  Department.finance: 'Finance',
  Department.law: 'Law',
  Department.it: 'IT',
  Department.medical: 'Medical',
};

const Map<Department, IconData> departmentIcons = {
  Department.finance: Icons.warning_amber_rounded, 
  Department.law: Icons.bug_report, 
  Department.it: Icons.cloud_off,
  Department.medical: Icons.sentiment_very_dissatisfied,
};


const Map<Department, Color> departmentColors = {
  Department.finance: Colors.green,
  Department.law: Colors.blue,
  Department.it: Colors.teal,
  Department.medical: Colors.purple,
};
