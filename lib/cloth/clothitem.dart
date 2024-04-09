import 'package:flutter/material.dart';

class ClothItem {
  String name;
  int count;

  ClothItem({required this.name, this.count = 0});
}

class ClothItemWidget extends StatelessWidget {
  final ClothItem clothItem;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  ClothItemWidget({
    required this.clothItem,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          clothItem.name,
          style: TextStyle(color: Colors.white),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.remove,
                color: Colors.white,
              ),
              onPressed: onDecrement,
            ),
            Text(
              '${clothItem.count}',
              style: TextStyle(color: Colors.white),
            ),
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: onIncrement,
            ),
          ],
        ),
      ],
    );
  }
}
