import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sltraveler/config.dart';
import 'station_row.dart';
import 'package:sltraveler/ui_common.dart';

final Tween<Offset> _kBottomUpTween = new Tween<Offset>(
  begin: const Offset(0.0, 0.1),
  end: Offset.zero,
);

PageRoute<Map> getPicker(Map loc) {
  return new PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return new Picker(loc: loc);
      },
      transitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return new FadeTransition(
          opacity: new CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn
          ),
          child: new SlideTransition(
            position: _kBottomUpTween.animate(
                new CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn
                )
            ),
            child: child,
          ),
        );
      }
  );
}

class Picker extends StatefulWidget {
  const Picker({
    Key key,
    this.loc
  }) : super(key: key);

  final Map loc;

  @override
  _PickerState createState() => new _PickerState();
}

class _PickerState extends State<Picker> {
  List stops = [];

  @override
  void initState() {
    super.initState();
    loadStops();
  }

  loadStops() async {
    String dataURL = "http://api.sl.se/api2/nearbystops.json?key=$keyNBS&originCoordLat=${widget.loc["latitude"]}&originCoordLong=${widget.loc["longitude"]}&maxResults=20";
    http.Response response = await http.get(dataURL);
    setState(() {
      stops = JSON.decode(response.body)['LocationList']['StopLocation'];
    });
  }

  List<Widget> getFavoriteStops() {
    return <Widget>[];
  }

  List<Widget> getNearestStops(BuildContext context) {
    if (stops.length == 0)
      return <Widget>[new Center(child: new CircularProgressIndicator())];

    return stops.map((i) => getRow(i, context, false)).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    rows.add(titleLabel("Favorithållplatser"));
    rows.addAll(getFavoriteStops());
    rows.add(titleLabel("Närliggande hållplatser"));
    rows.addAll(getNearestStops(context));

    return new Scaffold(
      appBar: new AppBar(title: new Text("Välj hållplats"), backgroundColor: appColor),
      body: new ListView(
        children: rows
      ),
    );
  }
}
