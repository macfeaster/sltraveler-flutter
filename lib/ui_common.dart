import 'package:flutter/material.dart';

int appColorInt = 0xFF3949AB;
Color appColor = new Color(appColorInt);

Widget titleLabel(String title) {
  return new Padding(
      padding: new EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 5.0),
      child: new Text(title,
        style: new TextStyle(
            color: Colors.indigo.shade600,
            fontWeight: FontWeight.bold
        ),
      )
  );
}