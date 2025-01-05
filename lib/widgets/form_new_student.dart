import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/department.dart';
import '../providers/provide_students.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewStudent extends ConsumerStatefulWidget {
  final int? studentIndex;

  const NewStudent({super.key, this.studentIndex});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewStudentState();
}

class _NewStudentState extends ConsumerState<NewStudent> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  Department _selectedDepartment = Department.it;
  Gender _selectedGender = Gender.male;
  int _grade = 50;

  @override
  void initState() {
    super.initState();
    if (widget.studentIndex != null) {
      final student = ref.read(studentsProvider)![widget.studentIndex!];
      _firstNameController.text = student.firstName;
      _lastNameController.text = student.lastName;
      _grade = student.grade;
      _selectedGender = student.gender;
      _selectedDepartment = student.department;
    }
  }
  
 void _saveStudent() async {
  try {
    if (widget.studentIndex != null) {
      await ref.read(studentsProvider.notifier).editStudent(
            widget.studentIndex!,
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _selectedDepartment,
            _selectedGender,
            _grade,
          );
    } else {
      await ref.read(studentsProvider.notifier).addStudent(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _selectedDepartment,
            _selectedGender,
            _grade,
          );
    }

    if (!context.mounted) return;

    Navigator.of(context).pop(null); 
  } catch (e) {
    if (!context.mounted) return;

    Navigator.of(context).pop('Failed to save student: ${e.toString()}'); 
  }
}



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add/Edit Student',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue, 
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue),
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Department>(
              value: _selectedDepartment,
              decoration: const InputDecoration(
                labelText: 'Department',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue),
                ),
              ),
              items: Department.values.map((dept) {
                return DropdownMenuItem(
                  value: dept,
                  child: Row(
                    children: [
                      Icon(
                        departmentIcons[dept],
                        size: 20,
                        color: Colors.lightBlue,
                      ),
                      const SizedBox(width: 8),
                      Text(departmentNames[dept]!),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedDepartment = value!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Gender>(
              value: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue),
                ),
              ),
              items: Gender.values.map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender == Gender.male ? 'Male' : 'Female'),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedGender = value!),
            ),
            const SizedBox(height: 12),
            const Text(
              'Grade:',
              style: TextStyle(fontSize: 16, color: Colors.lightBlue),
            ),
            Slider(
              value: _grade.toDouble(),
              min: 0,
              max: 100,
              divisions: 100,
              label: _grade.toString(),
              activeColor: Colors.lightBlue,
              onChanged: (value) => setState(() => _grade = value.toInt()),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: _saveStudent,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}