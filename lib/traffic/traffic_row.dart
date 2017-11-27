import 'package:flutter/material.dart';

import 'package:sltraveler/ui_common.dart';

ExpansionPanel getRow(Map item, BuildContext context) {
  var icons = <String, IconData>{
    "metro": Icons.directions_subway,
    "train": Icons.train,
    "local": Icons.directions_railway,
    "tram": Icons.tram,
    "bus": Icons.directions_bus,
    "fer": Icons.directions_boat
  };

  Widget event(Map e) {
    return new ListTile(
      subtitle: new Text(e["Message"]),
    );
  }

  return new ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return new ListTile(
            leading: new Icon(icons[item["Type"]]),
            title: new Text(item["Name"])
        );
      },
      body: new Column(
          children: item["Events"]
              .where((e) => e["EventId"] != 0)
              .map(event)
              .toList()
      ),
      isExpanded: true
  );
}