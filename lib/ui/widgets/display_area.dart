import 'package:flutter/material.dart';

class DisplayArea extends StatelessWidget {
  final String input;
  final String result;

  DisplayArea({required this.input, required this.result});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              input,
              style: TextStyle(fontSize: 32, color: Colors.black54),
            ),
            SizedBox(height: 8),
            Text(
              result,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
