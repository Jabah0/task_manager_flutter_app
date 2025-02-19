import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/enums/task_priority.dart';
import '../bloc/task_bloc.dart';

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key});

  @override
  _AddTaskSheetState createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDeadline = DateTime.now().add(const Duration(days: 1));
  TaskPriority _selectedPriority = TaskPriority.medium;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: "Title"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: "Description"),
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Deadline:"),
              TextButton(
                onPressed: _pickDeadline,
                child: Text("${_selectedDeadline.toLocal()}".split(' ')[0]),
              ),
            ],
          ),
          DropdownButton<TaskPriority>(
            value: _selectedPriority,
            onChanged: (priority) {
              if (priority != null) {
                setState(() => _selectedPriority = priority);
              }
            },
            items: TaskPriority.values.map((priority) {
              return DropdownMenuItem<TaskPriority>(
                value: priority,
                child: Text(priority.name.toUpperCase()),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: _addTask,
                child: const Text("Add"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickDeadline() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selected != null) setState(() => _selectedDeadline = selected);
  }

  void _addTask() {
    if (_titleController.text.isNotEmpty) {
      context.read<TaskBloc>().add(
            AddTaskEvent(
              title: _titleController.text,
              description: _descriptionController.text,
              deadline: _selectedDeadline,
              priority: _selectedPriority,
            ),
          );
      Navigator.pop(context);
    }
  }
}
