import 'package:flutter/material.dart';

class TodoItem {
  String task;
  bool isCompleted;
  DateTime? dueDate;
  String? category;

  TodoItem(this.task, {this.isCompleted = false, this.dueDate, this.category});

  void toggleComplete() {
    isCompleted = !isCompleted;
  }

  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
      'category': category,
    };
  }

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      json['task'],
      isCompleted: json['isCompleted'],
      dueDate: json['dueDate'],
      category: json['category'],
    );
  }
}

class EditTaskDialog extends StatefulWidget {
  final TodoItem? todo;

  EditTaskDialog({Key? key, this.todo}) : super(key: key);

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  TextEditingController? taskController;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    taskController = TextEditingController(text: widget.todo!.task);
    selectedDate = widget.todo!.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: taskController,
            decoration: InputDecoration(labelText: 'Task'),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Due Date:'),
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (selectedDate != null) {
                    setState(() {
                      this.selectedDate = selectedDate;
                    });
                  }
                },
                child: Text(
                  selectedDate != null
                      ? "${selectedDate?.toLocal()}".split(' ')[0]
                      : 'Select a date',
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final editedTask = TodoItem(
              taskController!.text,
              isCompleted: widget.todo!.isCompleted,
              dueDate: selectedDate,
              category: widget.todo!.category,
            );
            Navigator.of(context).pop(editedTask);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
