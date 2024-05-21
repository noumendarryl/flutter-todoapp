import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/views/view_todo.dart';

import '../widgets/checkbox.dart';

class DoneTodo extends StatefulWidget {
  final List<Map<String, dynamic>> todoList;
  final List<Map<String, dynamic>> doneTodoList;

  const DoneTodo({super.key, required this.todoList, required this.doneTodoList});

  @override
  State<DoneTodo> createState() => _DoneTodoState();
}

class _DoneTodoState extends State<DoneTodo> {
  Future<void> _saveDoneTodos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("doneTodos", jsonEncode(widget.doneTodoList));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, widget.todoList);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Done todos",
            style: TextStyle(fontSize: 20.0)),
        backgroundColor: const Color.fromRGBO(192, 192, 192, .5),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: CheckBox(
                  title: widget.doneTodoList[index]['title'],
                  isChecked: widget.doneTodoList[index]['isCompleted'],
                  onChanged: (bool? value) {
                    setState(() {
                      widget.doneTodoList[index]['isCompleted'] = value!;
                      if (!widget.doneTodoList[index]['isCompleted']) {
                        widget.todoList.add({
                          "title": widget.doneTodoList[index]['title'],
                          "description": widget.doneTodoList[index]
                          ['description'],
                          "isCompleted": widget.doneTodoList[index]['isCompleted'],
                          "created": widget.doneTodoList[index]['created'],
                        });
                        widget.doneTodoList.removeAt(index);
                      }
                    });
                    _saveDoneTodos();
                  },
                ),
                trailing: Wrap(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.visibility_outlined,
                        size: 22,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewTodo(
                                title: widget.doneTodoList[index]['title'],
                                description: widget.doneTodoList[index]
                                ['description'],
                                created: widget.doneTodoList[index]['created'],
                              )),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outlined,
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.doneTodoList.removeAt(index);
                        });
                        _saveDoneTodos();
                      },
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: widget.doneTodoList.length),
      ),
    );
  }
}