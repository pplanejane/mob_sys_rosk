import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/department.dart';
import '../providers/provide_students.dart';
import 'item_department.dart';

class DepartmentsScreen extends ConsumerWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    Map<Department, int> departmentStudentCounts = {};
    for (var department in Department.values) {
      departmentStudentCounts[department] = students == null 
      ? 0 
      : students.where((s) => s.department == department).length;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Departments',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 180,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: Department.values.length,
        itemBuilder: (context, index) {
          final department = Department.values[index];
          return InkWell(
            borderRadius: BorderRadius.circular(15),
            child: DepartmentItem(
              name: departmentNames[department]!,
              studentCount: departmentStudentCounts[department] ?? 0,
              color: departmentColors[department]!,
              icon: departmentIcons[department]!,
            ),
          );
        },
      ),
    );
  }
}
