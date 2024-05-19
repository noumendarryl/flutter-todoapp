import 'package:flutter/material.dart';
import 'package:todo_list/views/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
          textTheme:  Theme.of(context).textTheme.apply(
            fontFamily: 'Righteous',
          )
      ),
      home: const HomePage(),
    );
  }
}