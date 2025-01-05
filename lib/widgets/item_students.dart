import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/department.dart';

class StudentsItem extends StatelessWidget {
  final Student student;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const StudentsItem({
    super.key,
    required this.student,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor =
        student.gender == Gender.male ? Colors.blue.shade50 : Colors.pink.shade50;

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(
              '${student.firstName[0]}${student.lastName[0]}'.toUpperCase(),
            ),
          ),
          title: Text('${student.firstName} ${student.lastName}'),
          subtitle: Text('Department: ${departmentNames[student.department]}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}