import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {

  final String text;

  const FilterButton({required this.text});

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: () {},
      child: Text(text),
    );

  }
}