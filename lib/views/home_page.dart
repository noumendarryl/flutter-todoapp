import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/views/add_todo.dart';
import 'package:todo_list/views/done_todo.dart';
import 'package:todo_list/views/edit_todo.dart';
import 'package:todo_list/views/view_todo.dart';
import 'package:todo_list/widgets/checkbox.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _todoList = [];
  final List<Map<String, dynamic>> _doneTodoList = [];

  final String _created =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _init() {
    setState(() {
      _todoList.addAll([
        {
          "title": "Go to the market",
          "description": "Refill my fridge with new groceries",
          "isCompleted": false,
          "created": _created
        },
        {
          "title": "Buy some groceries",
          "description":
              "- Fruits \n- Vegetables \n- Irish Potatoes \n- Tomatoes",
          "isCompleted": false,
          "created": _created
        },
        {
          "title": "Pay a visit to grandma",
          "description": "Check on her since she's sick for very long time",
          "isCompleted": false,
          "created": _created
        },
        {
          "title": "Apply for internships",
          "description":
              "Start looking for companies where I can apply since internships are soon",
          "isCompleted": false,
          "created": _created
        },
        {
          "title": "Study today's lessons",
          "description":
              "Get prepared for tomorrow's CCTL by revising my courses",
          "isCompleted": false,
          "created": _created
        },
        {
          "title": "Plan my holiday trip",
          "description":
              "- Choose a nice destination \n- Check for a good place to stay \n- Buy an airplane ticket",
          "isCompleted": false,
          "created": _created
        },
      ]);
    });
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todos = prefs.getString('todos');
    final String? doneTodos = prefs.getString('doneTodos');
    if (todos != null && doneTodos != null) {
      setState(() {
        _todoList.addAll(List<Map<String, dynamic>>.from(jsonDecode(todos)));
        _doneTodoList
            .addAll(List<Map<String, dynamic>>.from(jsonDecode(doneTodos)));
      });
    } else {
      _init();
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("todos", jsonEncode(_todoList));
      prefs.setString("doneTodos", jsonEncode(_doneTodoList));
    });
  }

  Future<void> _callToDoForm(BuildContext context) async {
    final [title, description, created] = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTodoForm()),
    );
    setState(() {
      _todoList.add({
        "title": title,
        "description": description ?? "",
        "isCompleted": false,
        "created": created ?? _created
      });
    });
    _saveTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome 👋 to your todo app",
            style: TextStyle(fontSize: 20.0)),
        backgroundColor: const Color.fromRGBO(192, 192, 192, .5),
        actions: [
          IconButton(
              onPressed: () async {
                final List<Map<String, dynamic>> todoList =
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DoneTodo(
                                  todoList: _todoList,
                                  doneTodoList: _doneTodoList,
                                )));
                if (todoList.isNotEmpty) {
                  setState(() {
                    for (var todo in todoList) {
                      if (!_todoList.contains(todo)) {
                        _todoList.add(todo);
                      }
                    }
                  });
                }
                _saveTodos();
              },
              icon: const Icon(Icons.arrow_forward, size: 30.0))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: CheckBox(
                  title: _todoList[index]['title'],
                  isChecked: _todoList[index]['isCompleted'],
                  onChanged: (bool? value) {
                    setState(() {
                      _todoList[index]['isCompleted'] = value!;
                      if (_todoList[index]['isCompleted']) {
                        _doneTodoList.add({
                          "title": _todoList[index]['title'],
                          "description": _todoList[index]['description'],
                          "isCompleted": _todoList[index]['isCompleted'],
                          "created": _todoList[index]['created']
                        });
                        _todoList.removeAt(index);
                      }
                    });
                    _saveTodos();
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
                                    title: _todoList[index]['title'],
                                    description: _todoList[index]
                                        ['description'],
                                    created: _todoList[index]['created'],
                                  )),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 22,
                      ),
                      onPressed: () async {
                        final [newTitle, newDescription] = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditTodo(
                                  title: _todoList[index]['title'],
                                  description: _todoList[index]
                                      ['description'])),
                        );
                        if (newTitle.toString().isNotEmpty) {
                          setState(() {
                            _todoList.elementAt(index)['title'] = newTitle;
                            _todoList.elementAt(index)['description'] =
                                newDescription;
                          });
                        }
                        _saveTodos();
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outlined,
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          _todoList.removeAt(index);
                        });
                        _saveTodos();
                      },
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: _todoList.length),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _callToDoForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
