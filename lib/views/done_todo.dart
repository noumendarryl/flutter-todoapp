import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/views/view_todo.dart';

import '../todo.dart';
import '../widgets/checkbox.dart';

class DoneTodo extends StatefulWidget {
  final List<Todo> todoList;
  final List<Todo> doneTodoList;

  const DoneTodo(
      {super.key, required this.todoList, required this.doneTodoList});

  @override
  State<DoneTodo> createState() => _DoneTodoState();
}

class _DoneTodoState extends State<DoneTodo> {
  final FirebaseFirestore database = FirebaseFirestore.instance;
  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadDoneTodos();
  }

  Future<void> _loadTodos() async {
    var todos = await database.collection("Todos").where('uid', isEqualTo: _authInstance.currentUser!.uid).get();
    widget.todoList.clear();
    for (var doc in todos.docs) {
      widget.todoList.add(Todo(
          id: doc.id,
          uid: doc.data()["uid"],
          title: doc.data()["title"],
          description: doc.data()["description"],
          isCompleted: doc.data()["isCompleted"],
          created: doc.data()["created"]));
    }
    setState(() {});
  }

  Future<void> _loadDoneTodos() async {
    var doneTodos = await database.collection("DoneTodos").where('uid', isEqualTo: _authInstance.currentUser!.uid).get();
    widget.doneTodoList.clear();
    for (var doc in doneTodos.docs) {
      widget.doneTodoList.add(Todo(
          id: doc.id,
          uid: doc.data()["uid"],
          title: doc.data()["title"],
          description: doc.data()["description"],
          isCompleted: doc.data()["isCompleted"],
          created: doc.data()["created"]));
    }
    setState(() {});
  }

  Future<void> _deleteDoneTodos(id) async {
    await database.collection("DoneTodos").doc(id).delete();
    _loadDoneTodos();
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
        title: const Text("Done todos", style: TextStyle(fontSize: 20.0)),
        backgroundColor: const Color.fromRGBO(192, 192, 192, .5),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: CheckBox(
                  title: widget.doneTodoList[index].title,
                  isChecked: widget.doneTodoList[index].isCompleted,
                  onChanged: (bool? value) async {
                    setState(() {
                      widget.doneTodoList[index].isCompleted = value!;
                      if (!widget.doneTodoList[index].isCompleted) {
                        database.collection("Todos").add({
                          "uid": widget.doneTodoList[index].uid,
                          "title": widget.doneTodoList[index].title,
                          "description":
                              widget.doneTodoList[index].description ?? "",
                          "isCompleted": widget.doneTodoList[index].isCompleted,
                          "created": widget.doneTodoList[index].created,
                        }).then((doc) {
                          _loadTodos();
                        });

                        _deleteDoneTodos(widget.doneTodoList[index].id);
                      }
                    });
                    _loadDoneTodos();
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
                                    title: widget.doneTodoList[index].title,
                                    description:
                                        widget.doneTodoList[index].description,
                                    created: widget.doneTodoList[index].created,
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
                        _deleteDoneTodos(widget.doneTodoList[index].id);
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
