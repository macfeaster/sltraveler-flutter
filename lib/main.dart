import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'here_now/here_now.dart';
import 'traffic/traffic.dart';
import 'ui_common.dart';

class SLTraveler extends StatefulWidget {
  @override
  _SLTravelerState createState() => new _SLTravelerState();
}

class _SLTravelerState extends State<SLTraveler> {
  Location location;
  Map loc = <String, double>{};

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  getLocation() async {
    if (location == null)
      location = new Location();

    Map<String,double> currentLocation = await location.onLocationChanged.firstWhere((d) => d != null);

    if (mounted) {
      setState(() {
        loc = currentLocation;
      });
    }
  }

  Widget getApp() {
    if (loc.keys.length == 0) {
      return new Container(
          color: Colors.white,
          child: new Center(child: new CircularProgressIndicator())
      );
    } else {
      return new DefaultTabController(
          length: tabs.length,
          child: new Scaffold(
            appBar: new AppBar(
              elevation: 2.0,
              backgroundColor: appColor,
              title: const Text('SL Traveler'),
              bottom: new TabBar(
                isScrollable: false,
                tabs: tabs.map((TabContent choice) {
                  return new Tab(icon: new Icon(choice.icon));
                }).toList(),
              ),
            ),
            body: new TabBarView(
                children: <Widget>[
                  new HereNow(loc: loc),
                  new ChoiceCard(choice: tabs[1]),
                  new ChoiceCard(choice: tabs[2]),
                  new Traffic()
                ]
            ),
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        color: appColor,
        title: "SL Traveler",
        home: getApp()
    );
  }
}

class TabContent {
  const TabContent({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<TabContent> tabs = const <TabContent>[
  const TabContent(title: 'Här och nu', icon: Icons.directions_bus),
  const TabContent(title: 'Favoriter', icon: Icons.star),
  const TabContent(title: 'Reseplanerare', icon: Icons.directions),
  const TabContent(title: 'Trafikinformation', icon: Icons.error_outline)
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({ Key key, this.choice }) : super(key: key);
  final TabContent choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Card(
          color: Colors.white,
          child: new Center(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Icon(choice.icon, size: 128.0, color: textStyle.color),
                new Text(choice.title, style: textStyle),
                new Text("Kommer snart :)"),
              ],
            ),
          ),
        )
    );
  }
}


void main() {
  runApp(new SLTraveler());
}