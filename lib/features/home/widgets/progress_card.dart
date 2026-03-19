import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Tiến độ ôn tập', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          LinearProgressIndicator(value: 0.15),
          SizedBox(height: 6),
          Text('90/600 câu - 28 đúng, 62 sai'),
        ],
      ),
    );
  }



}