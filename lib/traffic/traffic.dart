import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sltraveler/config.dart';
import 'traffic_row.dart';

class Traffic extends StatefulWidget {
  @override
  _PickerState createState() => new _PickerState();
}

class _PickerState extends State<Traffic> {
  List info = [];

  @override
  void initState() {
    super.initState();
    loadTraffic();
  }

  loadTraffic() async {
    if (!mounted)
      return;

    String dataURL = "http://api.sl.se/api2/trafficsituation.json?key=$keyTS";
    http.Response response = await http.get(dataURL);

    if (mounted) {
      setState(() {
        info = JSON.decode(response.body)["ResponseData"]["TrafficTypes"];
      });
    }
  }

  Future<Null> doRefresh() async {
    await loadTraffic();
    return new Future<Null>.value();
  }

  List<Widget> getTraffic(BuildContext context) {
    if (info.length == 0)
      return <Widget>[new Center(child: new CircularProgressIndicator())];

    return <Widget>[new ExpansionPanelList(
      children: info.map((i) => getRow(i, context)).toList(growable: false),
    )];
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
        onRefresh: doRefresh,
        child: new ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: getTraffic(context)
        )
    );
  }
}
