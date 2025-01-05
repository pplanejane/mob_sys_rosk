import 'package:flutter/material.dart';

class DepartmentItem extends StatelessWidget {
  final String name;
  final int studentCount;
  final Color color;
  final IconData icon;

  const DepartmentItem({
    super.key,
    required this.name,
    required this.studentCount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 10),
          Text(name, style: const TextStyle(fontSize: 18)),
          Text('$studentCount students', style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
