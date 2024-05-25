import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/views/view_todo.dart';

import '../auth/login.dart';
import '../todo.dart';
import '../widgets/checkbox.dart';

import 'add_todo.dart';
import 'done_todo.dart';
import 'edit_todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore database = FirebaseFirestore.instance;
  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  final List<Todo> _todoList = [];
  final List<Todo> _doneTodoList = [];

  final String _created =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    final dumpTodos = [
      Todo(
          uid: _authInstance.currentUser!.uid,
          title: "Go to the market",
          description: "Refill my fridge with new groceries",
          isCompleted: false,
          created: _created),
      Todo(
          uid: _authInstance.currentUser!.uid,
          title: "Buy some groceries",
          description:
              "- Fruits \n- Vegetables \n- Irish Potatoes \n- Tomatoes",
          isCompleted: false,
          created: _created),
      Todo(
          uid: _authInstance.currentUser!.uid,
          title: "Pay a visit to grandma",
          description: "Check on her since she's sick for very long time",
          isCompleted: false,
          created: _created),
      Todo(
          uid: _authInstance.currentUser!.uid,
          title: "Apply for internships",
          description:
              "Start looking for companies where I can apply since internships are soon",
          isCompleted: false,
          created: _created),
      Todo(
          uid: _authInstance.currentUser!.uid,
          title: "Study today's lessons",
          description:
              "Get prepared for tomorrow's CCTL by revising my courses",
          isCompleted: false,
          created: _created),
      Todo(
          uid: _authInstance.currentUser!.uid,
          title: "Plan my holiday trip",
          description:
              "- Choose a nice destination \n- Check for a good place to stay \n- Buy an airplane ticket",
          isCompleted: false,
          created: _created),
    ];

    var existingTodos = await database
        .collection("Todos")
        .where('uid', isEqualTo: _authInstance.currentUser!.uid)
        .get();

    if (existingTodos.docs.isEmpty) {
      for (var dumpTodo in dumpTodos) {
        database.collection("Todos").add({
          "uid": dumpTodo.uid,
          "title": dumpTodo.title,
          "description": dumpTodo.description,
          "isCompleted": false,
          "created": dumpTodo.created,
        });
      }
    }

    _loadTodos();
  }

  Future<void> _loadTodos() async {
    var todos = await database
        .collection("Todos")
        .where('uid', isEqualTo: _authInstance.currentUser!.uid)
        .get();
    _todoList.clear();
    for (var doc in todos.docs) {
      _todoList.add(Todo(
          id: doc.id,
          uid: doc.data()["uid"],
          title: doc.data()["title"],
          description: doc.data()["description"],
          isCompleted: doc.data()["isCompleted"],
          created: doc.data()["created"]));
    }
    setState(() {});
  }

  Future<void> _saveTodos(
      String title, String? description, String? created) async {
    database.collection("Todos").add({
      "uid": _authInstance.currentUser!.uid,
      "title": title,
      "description": description ?? "",
      "isCompleted": false,
      "created": created ?? _created,
    }).then((doc) {
      _loadTodos();
    });
  }

  Future<void> _loadDoneTodos() async {
    var doneTodos = await database
        .collection("DoneTodos")
        .where('uid', isEqualTo: _authInstance.currentUser!.uid)
        .get();
    _doneTodoList.clear();
    for (var doc in doneTodos.docs) {
      _doneTodoList.add(Todo(
          id: doc.id,
          uid: doc.data()["uid"],
          title: doc.data()["title"],
          description: doc.data()["description"],
          isCompleted: doc.data()["isCompleted"],
          created: doc.data()["created"]));
    }
    setState(() {});
  }

  Future<void> _saveDoneTodos(String title, String? description,
      bool isCompleted, String? created) async {
    database.collection("DoneTodos").add({
      "uid": _authInstance.currentUser!.uid,
      "title": title,
      "description": description ?? "",
      "isCompleted": isCompleted,
      "created": created ?? _created,
    }).then((doc) {
      _loadDoneTodos();
    });
  }

  Future<void> _deleteTodos(id) async {
    await database.collection("Todos").doc(id).delete();
    _loadTodos();
  }

  Future<void> _callToDoForm(BuildContext context) async {
    final [title, description, created] = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTodoForm()),
    );

    if (title.toString().isNotEmpty &&
        description.toString().isNotEmpty &&
        created.toString().isNotEmpty) {
      setState(() {
        _saveTodos(title, description, created);
      });
    }
  }

  Future<void> _logout() async {
    await _authInstance.signOut();
    // Handle successful logout, e.g., navigate to the login screen
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome 👋 to your todo app",
            style: TextStyle(fontSize: 20.0)),
        backgroundColor: const Color.fromRGBO(192, 192, 192, .5),
        actions: [
          Wrap(
            children: [
              IconButton(
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DoneTodo(
                                  todoList: _todoList,
                                  doneTodoList: _doneTodoList,
                                )));
                    _loadTodos();
                  },
                  icon: const Icon(Icons.check_box_outlined)),
              IconButton(
                  onPressed: () async {
                    _logout();
                  },
                  icon: const Icon(Icons.logout_outlined)),
            ],
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: CheckBox(
                  title: _todoList[index].title,
                  isChecked: _todoList[index].isCompleted,
                  onChanged: (bool? value) async {
                    setState(() {
                      _todoList[index].isCompleted = value!;

                      if (_todoList[index].isCompleted) {
                        _saveDoneTodos(
                            _todoList[index].title,
                            _todoList[index].description,
                            _todoList[index].isCompleted,
                            _todoList[index].created);

                        _deleteTodos(_todoList[index].id);
                      }
                    });

                    _loadTodos();
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
                                    title: _todoList[index].title,
                                    description: _todoList[index].description,
                                    created: _todoList[index].created,
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
                                  title: _todoList[index].title,
                                  description: _todoList[index].description)),
                        );

                        if (newTitle.toString().isNotEmpty &&
                            newDescription.toString().isNotEmpty) {
                          await database
                              .collection("Todos")
                              .doc(_todoList[index].id)
                              .update({
                            "title": newTitle,
                            "description": newDescription
                          });
                        }

                        _loadTodos();
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outlined,
                        size: 22,
                      ),
                      onPressed: () async {
                        _deleteTodos(_todoList[index].id);
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
