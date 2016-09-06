import 'package:flutter/material.dart';
import "package:trmsta_nohttp/trmsta.dart";
import "package:flutter/http.dart" as http;
//import "dart:async";
import "location.dart";

void main() {
  runApp(new MaterialApp(
      title: 'TRMSta ListNow',
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new TrmStaListNow()));
}

class TrmStaListNow extends StatefulWidget {
  TrmStaListNow({Key key}) : super(key: key);

  @override
  _TrmStaListNowState createState() => new _TrmStaListNowState();
}

class _TrmStaListNowState extends State<TrmStaListNow> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  /*
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
      */
  static final GlobalKey<ScrollableState> _scrollableKey =
      new GlobalKey<ScrollableState>();
  List<AllSta> _lista;
  DateTime _when;

  @override
  void initState() {
    super.initState();
    _download();
  }

  void _download() {
    download((String url) => http.read(url)).then((Downloaded down) {
      setState(() {
        _when = down.time;
        _lista = down.ParseAll();
      });
    });
  }

/*
  Future<Null> _refresh() async {
    Completer<Null> completer = new Completer<Null>();
    _download();
    return completer.future.then((_) {});
  }
  */

  @override
  Widget build(BuildContext context) {
    Widget body = new ScrollConfiguration(child: new MaterialList(
        type: MaterialListType.threeLine,
        //padding: const EdgeInsets.all(8.0),
        scrollableKey: _scrollableKey,
        children: (_lista == null
            ? new List<ListItem>()
            : (_lista.map((AllSta item) {
                JavaLocation ourloc = getLastLocation();
                return new ListItem(
                    isThreeLine: true,
                    leading: new CircleAvatar(
                        child: new Text(item.locrow.stanum.toString())),
                    title: new Text(item.data.addr +
                        " " +
                        item.locrow.row.toString() +
                        ourloc
                            .distanceTo(new JavaLocation(
                                getLastLocation(),
                                item.locrow.location.lat.toDouble(),
                                item.locrow.location.lon.toDouble()))
                            .toString() +
                        "m"),
                    subtitle: new Text("█" * item.locrow.row.dostrow +
                        "▒" * item.locrow.row.wolrow));
              })))));
    /*
    body = new RefreshIndicator(
        key: _refreshIndicatorKey,
        child: body,
        refresh: _refresh,
        scrollableKey: _scrollableKey,
        location: RefreshIndicatorLocation.top);
        */
    return new Scaffold(
        key: _scaffoldKey,
        //scrollableKey: _scrollableKey,
        appBar: new AppBar(
            title: new Text('Stations ${_when.toString()}'),
            actions: <Widget>[
              new IconButton(
                  onPressed: _download,
                  tooltip: 'Download',
                  icon: new Icon(Icons.refresh))
            ]),
        body: body);
  }
}
