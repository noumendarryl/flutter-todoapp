import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTodoForm extends StatefulWidget {
  const AddTodoForm({super.key});

  @override
  State<AddTodoForm> createState() => _AddTodoFormState();
}

class _AddTodoFormState extends State<AddTodoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String _created = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  String _title = '';
  String _description = '';

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
        title: const Text("Add new todo", style: TextStyle(fontSize: 20.0)),
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
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Write down your description",
                  ),
                  maxLines: 5,
                  onSaved: (value) {
                    _description = value!;
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
                        Navigator.pop(context, [_title, _description, _created]);
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
                      'Add Todo',
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
