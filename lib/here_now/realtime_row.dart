import 'package:flutter/material.dart';

Widget getRow(Map item, IconData icon) {
  Widget getStatus(int late) {
    if (late == -1) {
      return new Text("TABELL",
          style: new TextStyle(
              fontSize: 12.0,
              color: Colors.black45,
              fontWeight: FontWeight.w100
          )
      );
    } else if (late < 2) {
      return new Text("I TID",
          style: new TextStyle(
              fontSize: 12.0,
              color: const Color(0xFF2e7d32),
              fontWeight: FontWeight.w500
          )
      );
    } else {
      return new Text("+${item["Late"]} MIN",
        style: new TextStyle(
            fontSize: 12.0,
            color: Colors.red.shade900,
            fontWeight: FontWeight.w500
        ),
      );
    }
  }

  return new Container(
      decoration: const BoxDecoration(
          border: const Border(
              bottom: const BorderSide(width: 1.0, color: Colors.black12)
          )
      ),
      child: new Padding(
          padding: new EdgeInsets.fromLTRB(16.0, 11.0, 16.0, 8.0),
          child: new Row(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(right: 10.0),
                  child: new Icon(icon, size: 18.0, color: Colors.black87),
                ),
                new Container(
                    width: 55.0,
                    color: Colors.black12,
                    child: new Center(
                        child: new Padding(
                            padding: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
                            child: new Text(item["LineNumber"],
                                style: new TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87
                                )
                            )
                        )
                    )
                ),
                new Expanded(
                    child: new Padding(
                        padding: new EdgeInsets.symmetric(horizontal: 10.0),
                        child: new Text(item["Destination"],
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400
                            )
                        )
                    )
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Text(item["DisplayTime"].toString().toUpperCase(),
                      style: (item["DisplayTime"].toString().toUpperCase() == "NU") ?
                      new TextStyle(
                          fontSize: 13.0,
                          color: const Color(0xFF2e7d32),
                          fontWeight: FontWeight.w700
                      ) : new TextStyle(
                          fontSize: 13.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    getStatus(item["Late"])
                  ],
                )
              ]
          )
      )
  );
}
