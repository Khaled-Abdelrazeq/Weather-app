import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

//  String url = "https://api.apixu.com/v1/current.json?key=557f85f610cd4b45996224516190608&q=Paris";
  String url = "https://api.apixu.com/v1/current.json?key=557f85f610cd4b45996224516190608&q=El-Masura";
  Map result;

  Future<Map> _getData() async{

    var response = await http.get(Uri.parse(url), headers: {"Accept": "Application/json"});

    setState(() {
      result = jsonDecode(response.body);
    });


    return result;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather app"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: result.length == null? 0 : result.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text('location: ${result['current']['temp_c']}'),
                )
              ],
            );
          }
          ),
    );
  }
}
