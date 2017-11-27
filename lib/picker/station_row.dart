import 'package:flutter/material.dart';

Widget getRow(Map item, BuildContext context, bool favorite) {
  return new Container(
      height: 47.0,
      padding: new EdgeInsets.symmetric(horizontal: 16.0),
      decoration: const BoxDecoration(
          border: const Border(
              bottom: const BorderSide(width: 1.0, color: Colors.black12)
          )
      ),
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Container(
              alignment: Alignment.centerLeft,
              width: 56.0,
              child: new Icon(favorite ? Icons.star : Icons.star_border, size: 24.0, color: Colors.greenAccent),
            ),
            new Expanded(
                child: new InkWell(
                    onTap: () {
                      Navigator.of(context).pop(item);
                    },
                    child: new Padding(
                        padding: new EdgeInsets.symmetric(vertical: 13.0),
                        child: new Text(item["name"],
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400
                            )
                        )
                    )
                )
            ),
            new Text("${item["dist"]} M", style: new TextStyle(
                fontSize: 13.0
            ))
          ]
      )
  );
}
