import 'package:flutter/material.dart';

class EditTodo extends StatefulWidget {
  final String title;
  final String? description;

  const EditTodo(
      {super.key,
      required this.title,
      this.description});

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    String? description = widget.description;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Edit todo", style: TextStyle(fontSize: 20.0)),
        backgroundColor: const Color.fromRGBO(192, 192, 192, .5),
      ),
      body: Container(
        padding: const EdgeInsets.all(40.0),
        color: Colors.white70,
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter your today's task",
                  ),
                  initialValue: title,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      title = value!;
                    });
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Write down your description",
                  ),
                  initialValue: description,
                  maxLines: 5,
                  onSaved: (value) {
                    setState(() {
                      description = value!;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: TextButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid
                      if (_formKey.currentState!.validate()) {
                        // Process data
                        _formKey.currentState!.save();
                        Navigator.pop(
                            context, [title, description]);
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(192, 192, 192, .5),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.all(18.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                    child: const Text(
                      'Update Todo',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
