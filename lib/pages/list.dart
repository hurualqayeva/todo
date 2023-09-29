import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../item/items.dart';

class TodoList extends StatefulWidget {
  final String? category;

  TodoList({Key? key, this.category}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoItem> todos = [];
  List<TodoItem> inProgressTodos = [];
  List<TodoItem> doneTodos = [];
  TextEditingController todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: todoController,
            decoration: InputDecoration(labelText: 'Add a new task'),
            onSubmitted: (task) {
              setState(() {
                todos.add(TodoItem(task, category: widget.category));
                todoController.clear();
                _saveTasks();
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _getTaskCount(),
            itemBuilder: (context, index) {
              final todoItem = _getTaskByIndex(index);
              return _buildTaskItem(todoItem, index);
            },
          ),
        ),
      ],
    );
  }

  int _getTaskCount() {
    if (widget.category == "To Do") {
      return todos.length;
    } else if (widget.category == "In Progress") {
      return inProgressTodos.length;
    } else if (widget.category == "Done") {
      return doneTodos.length;
    }
    return 0;
  }

  TodoItem _getTaskByIndex(int index) {
    if (widget.category == "To Do") {
      return todos[index];
    } else if (widget.category == "In Progress") {
      return inProgressTodos[index];
    } else if (widget.category == "Done") {
      return doneTodos[index];
    }
    return TodoItem("", category: widget.category);
  }

  Widget _buildTaskItem(TodoItem todoItem, int index) {
     Color itemColor;
  if (widget.category == "To Do") {
    itemColor = Colors.red; 
  } else if (widget.category == "In Progress") {
    itemColor = Color.fromARGB(255, 206, 188, 29); 
  } else if (widget.category == "Done") {
    itemColor = Colors.green; 
  } else {
    itemColor = Colors.black; 
  }
  return ListTile(
    title: Text(
      todoItem.task,
      style: TextStyle(
        decoration: todoItem.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
        color: itemColor,
      ),
    ),
    subtitle: Text(
      'Due: ${todoItem.dueDate ?? "Not specified"}',
      style: TextStyle(
        color: Colors.grey,
      ),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(todoItem.isCompleted ? Icons.undo : Icons.check),
          onPressed: () {
            setState(() {
              if (widget.category == "To Do") {
                todoItem.toggleComplete();
                if (todoItem.isCompleted) {
                  doneTodos.add(todoItem);
                  todos.remove(todoItem);
                } else {
                  inProgressTodos.add(todoItem);
                  todos.remove(todoItem);
                }
              } else if (widget.category == "In Progress") {
                todoItem.toggleComplete();
                doneTodos.add(todoItem);
                inProgressTodos.remove(todoItem);
              } else if (widget.category == "Done") {
                  inProgressTodos.add(todoItem);
                  doneTodos.remove(todoItem);
                todoItem.toggleComplete();
                
              }
              _saveTasks();
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() {
              if (widget.category == "To Do") {
                todos.remove(todoItem);
              } else if (widget.category == "In Progress") {
                inProgressTodos.remove(todoItem);
              } else if (widget.category == "Done") {
                doneTodos.remove(todoItem);
              }
              _saveTasks();
            });
          },
        ),
      ],
    ),
    onTap: () {
      _editTask(todoItem, index);
    },
  );
}



void _editTask(TodoItem todoItem, int index) {
}

Future<void> _loadTasks() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final todoList = prefs.getStringList('todos');
  final inProgressList = prefs.getStringList('inProgress');
  final doneList = prefs.getStringList('done');

  if (todoList != null) {
    todos = todoList.map((taskJson) => TodoItem.fromJson(jsonDecode(taskJson))).toList();
  }
  if (inProgressList != null) {
    inProgressTodos = inProgressList.map((taskJson) => TodoItem.fromJson(jsonDecode(taskJson))).toList();
  }
  if (doneList != null) {
    doneTodos = doneList.map((taskJson) => TodoItem.fromJson(jsonDecode(taskJson))).toList();
  }

  setState(() {});
}

Future<void> _saveTasks() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final todoList = todos.map((todoItem) => jsonEncode(todoItem.toJson())).toList();
  final inProgressList = inProgressTodos.map((todoItem) => jsonEncode(todoItem.toJson())).toList();
  final doneList = doneTodos.map((todoItem) => jsonEncode(todoItem.toJson())).toList();

  prefs.setStringList('todos', todoList);
  prefs.setStringList('inProgress', inProgressList);
  prefs.setStringList('done', doneList);
}

}
