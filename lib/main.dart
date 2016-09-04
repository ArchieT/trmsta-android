import 'package:flutter/material.dart';
import "package:trmsta_nohttp/trmsta.dart";
import "package:flutter/http.dart" as http;
import "dart:async";

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
  List<AllSta> _lista;
  DateTime _when;

  void _download() async {
    download((String url) => http.read(url)).then((Downloaded down) {
      setState(() {
        _when = down.time;
        _lista = down.ParseAll();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Stations ${_when.toString()}')),
        body: new ScrollableList(
            children: _lista == null
                ? []
                : _lista.map((AllSta our) => new Text(our.toString(),
                    key: new ValueKey<int>(our.locrow.stanum))),
            itemExtent: 50.0),
        floatingActionButton: new FloatingActionButton(
            onPressed: _download,
            tooltip: 'Download',
            child: new Icon(Icons.refresh)));
  }
}
