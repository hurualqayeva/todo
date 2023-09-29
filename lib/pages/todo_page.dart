import 'package:flutter/material.dart';
import 'list.dart';

class TodoApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200], 
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
        ),
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'To-Do App',
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold, 
              ),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'To Do',
                  icon: Icon(Icons.checklist), 
                ),
                Tab(
                  text: 'In Progress',
                  icon: Icon(Icons.timer), 
                ),
                Tab(
                  text: 'Done',
                  icon: Icon(Icons.check_circle), 
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TodoList(category: 'To Do'),
              TodoList(category: 'In Progress'),
              TodoList(category: 'Done'),
            ],
          ),
        ),
      ),
    );
  }
}
