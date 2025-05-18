import 'package:flutter/material.dart';

class ClassificatioinItem extends StatelessWidget {
  final String item;
  final String value;

  const ClassificatioinItem({
    super.key,
    required this.item,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          Text(item, style: TextStyle(fontSize: 18)),
          const Spacer(),
          Text(value, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
