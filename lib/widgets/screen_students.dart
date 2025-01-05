import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import '../providers/provide_students.dart';
import 'form_new_student.dart';
import 'item_students.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

void _showNewStudentModal(BuildContext context, WidgetRef ref,
    {Student? student, int? index}) {
  showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => NewStudent(
      studentIndex: index,
    ),
  ).then((error) {
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  });
}



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);
    final notifier = ref.watch(studentsProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (notifier.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              notifier.errorMessage!,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        notifier.clearError();
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Student Directory',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: notifier.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : students == null || students.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.people_outline,
                        size: 80,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No students added yet!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _showNewStudentModal(context, ref),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Student'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 4.0),
                      child: StudentsItem(
                        student: student,
                        onDelete: () {
                          ref.read(studentsProvider.notifier).removeStudent(index);
                          final container =
                              ProviderScope.containerOf(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Student deleted'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  container
                                      .read(studentsProvider.notifier)
                                      .undo();
                                },
                              ),
                            ),
                          ).closed.then((value) {
                            if (value != SnackBarClosedReason.action) {
                              ref
                                  .read(studentsProvider.notifier)
                                  .removeStudentOnServer(student);
                            }
                          });
                        },
                        onTap: () => _showNewStudentModal(context, ref,
                            student: student, index: index),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewStudentModal(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Student'),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

}
