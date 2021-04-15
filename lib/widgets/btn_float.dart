import 'package:flutter/material.dart';

class BtnFloat extends StatelessWidget {
  IconData iconData;
  double maxRadius;
  VoidCallback onPressed;

  BtnFloat(
      {required this.iconData,
      required this.maxRadius,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: maxRadius,
        child: IconButton(
          icon: Icon(
            iconData,
            color: Colors.black87,
          ),
          onPressed: this.onPressed,
        ),
      ),
    );
  }
}
