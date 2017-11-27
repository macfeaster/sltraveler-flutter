import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'realtime_row.dart';
import 'package:sltraveler/ui_common.dart';
import 'package:sltraveler/config.dart';
import 'package:sltraveler/picker/picker.dart';

class HereNow extends StatefulWidget {
  const HereNow({ Key key, this.loc }) : super(key: key);
  final Map<String, double> loc;

  @override
  _HereNowState createState() => new _HereNowState();
}

class _HereNowState extends State<HereNow> {
  Map closestStop;
  Map<String, List> departures = {};

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await loadNearestStop();
    loadData();
  }

  List<Widget> getBody() {
    return departures.keys.length == 0 ? <Widget>[getProgressDialog()] : getDepartures();
  }

  getProgressDialog() {
    return new Container(
        height: 100.0,
        child: new Center(child: new CircularProgressIndicator())
    );
  }

  List<Widget> getDepartures() {
    List<Widget> deps = <Widget>[
      getDeparturesForType("Tunnelbana", departures["metros"], Icons.directions_subway),
      getDeparturesForType("Pendeltåg", departures["trains"], Icons.directions_railway),
      getDeparturesForType("Buss", departures["buses"], Icons.directions_bus),
      getDeparturesForType("Lokalbana", departures["trams"], Icons.tram),
      getDeparturesForType("Båt", departures["ships"], Icons.directions_boat)]
        .where((widget) => widget != null)
        .toList(growable: false);

    if (deps.length > 0)
      return deps;
    else
      return <Widget>[new Container(
        padding: new EdgeInsets.symmetric(vertical: 50.0),
        child: new Center(
            child: new Column(
                children: <Widget>[
                  new Icon(Icons.brightness_3, size: 128.0, color: Colors.black12),
                  new Text("Inga avgångar", style: new TextStyle(
                      color: Colors.black12,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0
                  )),
                ]
            )
        ),
      )];
  }

  Widget getDeparturesForType(String title, List source, IconData icon) {
    List<Widget> l = <Widget>[titleLabel(title)];
    l.addAll(source.map((i) => getRow(i, icon)));

    if (source.length > 0)
      return new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: l
      );
    else return null;
  }

  loadNearestStop() async {
    if (!mounted)
      return;

    String dataURL = "http://api.sl.se/api2/nearbystops.json?key=$keyNBS&originCoordLat=${widget.loc["latitude"]}&originCoordLong=${widget.loc["longitude"]}&maxResults=2";
    http.Response response = await http.get(dataURL);

    if (mounted) {
      setState(() {
        closestStop = JSON.decode(response.body)['LocationList']['StopLocation'][0];
      });
    }
  }

  loadData() async {
    if (!mounted)
      return;

    String site = closestStop["id"].toString();
    String siteID = site.substring(site.length - 4);
    String dataURL = "http://api.sl.se/api2/realtimedeparturesV4.json?key=$keyRT&siteid=$siteID&timewindow=30";
    http.Response response = await http.get(dataURL);

    print("loadData called!");

    if (mounted) {
      setState(() {
        process(List list) {
          return list.map((e) {
            if (e["ExpectedDateTime"] == null ||
                e["TimeTabledDateTime"] == null) {
              e["Late"] = -1;
              return e;
            }

            var expected = DateTime.parse(e["ExpectedDateTime"]);
            var timetabled = DateTime.parse(e["TimeTabledDateTime"]);
            Duration late = expected.difference(timetabled);
            e["Late"] = late.inMinutes;
            return e;
          }).toList();
        }

        departures["metros"] = process(JSON.decode(response.body)['ResponseData']['Metros']);
        departures["buses"] = process(JSON.decode(response.body)['ResponseData']['Buses']);
        departures["trains"] = process(JSON.decode(response.body)['ResponseData']['Trains']);
        departures["trams"] = process(JSON.decode(response.body)['ResponseData']['Trams']);
        departures["ships"] = process(JSON.decode(response.body)['ResponseData']['Ships']);
      });
    }
  }

  refresh() async {
    departures = {};
    closestStop = null;
    await init();
  }

  Future<Null> doRefresh() async {
    await refresh();
    return new Future<Null>.value();
  }

  Future<Null> changeStation() async {
    Map selectedStation = await Navigator.of(context).push(getPicker(widget.loc));

    if (selectedStation != null) {
      setState(() {
        closestStop = selectedStation;
      });
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
        onRefresh: doRefresh,
        child: new ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                              child: (closestStop != null) ? new InkResponse(
                                  containedInkWell: false,
                                  radius: 150.0,
                                  highlightColor: Colors.transparent,
                                  onTap: changeStation,
                                  child: new Padding(
                                      padding: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                      child: new Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(closestStop["name"], style: new TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400
                                          )),
                                          new Padding(
                                              padding: new EdgeInsets.only(top: 3.0),
                                              child: new Text("${closestStop["dist"]} meter")
                                          )
                                        ],
                                      ))) : new Center(child: new CircularProgressIndicator())
                          ),
                          new IconButton(
                            onPressed: refresh,
                            padding: EdgeInsets.zero,
                            icon: new Icon(Icons.refresh, color: Colors.black26, size: 30.0),
                          ),
                          new Padding(
                              padding: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                              child: new IconButton(
                                  onPressed: null,
                                  icon: new Icon(Icons.star_border, color: Colors.greenAccent, size: 30.0)
                              )
                          )
                        ],
                      ),
                    ),
                    new Container(
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          boxShadow: <BoxShadow>[
                            new BoxShadow(
                                color: const Color(0xee000000),
                                offset: new Offset(0.0, 1.0),
                                blurRadius: 2.0
                            )
                          ]
                      ),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: getBody(),
                      ),
                    ),
                    new Padding(padding: new EdgeInsets.all(15.0))
                  ]
              )
            ]
        )
    );
  }
}
