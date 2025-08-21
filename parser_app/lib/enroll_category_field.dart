import 'package:flutter/material.dart';

class EnrollCategoryField extends StatefulWidget {
  final String item;

  const EnrollCategoryField({super.key, required this.item});

  @override
  State<EnrollCategoryField> createState() => EnrollCategoryFieldState();
}

class EnrollCategoryFieldState extends State<EnrollCategoryField> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [Text(widget.item)]);
  }
}
