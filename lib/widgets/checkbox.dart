import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  final String title;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const CheckBox(
      {super.key,
      required this.title, required this.isChecked, required this.onChanged});

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.isChecked,
          onChanged: widget.onChanged,
        ),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          widget.title,
          style: TextStyle(
            color: widget.isChecked
                ? Colors.deepPurpleAccent
                : const Color.fromRGBO(84, 84, 84, 1),
            fontSize: 16.0,
            decoration: widget.isChecked
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
