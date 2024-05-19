import 'package:flutter/material.dart';

class ViewTodo extends StatelessWidget {
  final String title;
  final String? description;
  final String created;

  const ViewTodo({super.key, required this.title, this.description, required this.created});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Todo details", style: TextStyle(fontSize: 20.0)),
        backgroundColor: const Color.fromRGBO(192, 192, 192, .5),
      ),
      body: Container(
        padding: const EdgeInsets.all(40.0),
        color: Colors.white70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 24.0)),
            const SizedBox(height: 5.0,),
            Text("Created on $created", style: const TextStyle(color: Color.fromRGBO(84, 84, 84, 1), fontSize: 15.0)),
            const SizedBox(height: 28.0,),
            Text(description!, style: const TextStyle(fontSize: 17.0)),
          ],
        ),
      ),
    );
  }

}