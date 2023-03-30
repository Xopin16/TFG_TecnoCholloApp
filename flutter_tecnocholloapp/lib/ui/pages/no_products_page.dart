import 'package:flutter/material.dart';

class NoProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 96.0,
            color: Colors.grey[500],
          ),
          SizedBox(height: 16.0),
          Text(
            ("NO HAY PRODUCTOS"),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
