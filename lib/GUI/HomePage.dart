import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:weather_app/Services/SharedPreferencesEx.dart';
import 'package:weather_app/Services/sh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  double width; // Width of screen

  // Shared Preferences to store and retrieve data
//  SharedPreferencesEx _preferencesEx;
//  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
    SharedPreferencesTest _preferencesTest = SharedPreferencesTest();
  // Api link
  String url =
      "https://api.apixu.com/v1/current.json?key=557f85f610cd4b45996224516190608&q=Kafr%20Allam,MenyetEl-Nasr";

  String title = ""; // City name
  String time = "", date = "", condition = "";
  String iconUrl = "";
  int temp = 0; // in Celsius
  String lastUpdate;

  int fahrenheit = 0;
  double pressure = 0.0, windSpeed = 0.0;
  int visibility = 0;
  int humidity = 0, cloud = 0, uv = 0;
  String windDirection = "";
  String lastDateAndTime = "";

  String tempValString = "";
  int tempValInt = 0;
  double tempValDouble = 0.0;

  bool check = false;
  // Get Weather data from Api
  Map result;
  Future<Map> _getWeatherData() async {
//    check = await checkConnectivity();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        check =  true;
      }
    } on SocketException catch (_) {
      print('not connected');
      check = false;
    }
    var response;
    if(check) {
      try {
        response = await http.get(
            Uri.parse(url), headers: {"Accept": "Application/json"});
      }catch(e){
        print("Error: $e");
      }
        setState(() {
          width = MediaQuery
              .of(context)
              .size
              .width;
          result = jsonDecode(response.body);
          initiateVariables();
        });

    }else{
      setState(() {
        initiateVariables();
      });
    }

    return result;
  }

//  Future<bool> checkConnectivity() async{
//    bool check;
//    setState(() async {
//    try {
//      final result = await InternetAddress.lookup('google.com');
//      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//        print('connected');
//        check =  true;
//      }
//    } on SocketException catch (_) {
//      print('not connected');
//      check = false;
//    }
//    });
//    return check;
//  }

//  Future<Null> addString(String key, String value) async {
//    final SharedPreferences preferences = await _pref;
//    preferences.setString(key, value);
//
//    setState(() {
//    });
//  }
//  Future<Null> addInt(String key, int value) async {
//    final SharedPreferences preferences = await _pref;
//    preferences.setInt(key, value);
//
//    setState(() {
//    });
//  }
//  Future<Null> addDouble(String key, double value) async {
//    final SharedPreferences preferences = await _pref;
//    preferences.setDouble(key, value);
//
//    setState(() {
//    });
//  }
//
//  Future<Null> getString(String key) async {
//    final SharedPreferences preferences = await _pref;
//    setState(() {
//      tempValString = preferences.getString(key);
//    });
//  }
//  Future<Null> getInt(String key) async {
//    final SharedPreferences preferences = await _pref;
//    setState(() {
//      tempValInt = preferences.getInt(key);
//    });
//  }
//  Future<Null> getDouble(String key) async {
//    final SharedPreferences preferences = await _pref;
//    setState(() {
//      tempValDouble = preferences.getDouble(key);
//    });
//  }

  getFromShared() async {
    title = await _preferencesTest.getSortingOrder("title");
    condition = await _preferencesTest.getSortingOrder("condition");
    time = await _preferencesTest.getSortingOrder("time");
    date = await _preferencesTest.getSortingOrder("date");
    lastDateAndTime =
        await _preferencesTest.getSortingOrder("lastDateAndTime");
    lastUpdate = await _preferencesTest.getSortingOrder("lastUpdate");
    iconUrl = await _preferencesTest.getSortingOrder("iconUrl");
    temp = await _preferencesTest.getInt("temp");
    fahrenheit = await _preferencesTest.getInt("fahrenheit");
    visibility = await _preferencesTest.getInt("visibility");
    humidity = await _preferencesTest.getInt("humidity");
    cloud = await _preferencesTest.getInt("cloud");
    uv = await _preferencesTest.getInt("uv");
    pressure = await _preferencesTest.getDouble("pressure");
    windSpeed = await _preferencesTest.getDouble("windSpeed");
    windDirection =
        await _preferencesTest.getSortingOrder("windDirection");
  }

  void initiateVariables() async{
    String lastUpdatePref = await _preferencesTest.getSortingOrder("lastDateAndTime");
    setState(()  {
      // Shared Preferences

      print('lkjulkfdjglkdfgjlkdfgjkldfjgldfjglkjulkfdjglkdfgjlkdfgjkldfjgldffjgldfjglkdfLastUpdatePref   $lastUpdatePref');

      if(!check) {
        lastDateAndTime = "Fady ya m3lm";
        print('lkjulkfdjglkdfgjlkdfgjkldfjgldfjglkjulkfdjglkdfgjlkdfgjkldfjgldfjfjgldfjglkdfLastUpdateURL   $lastDateAndTime');
        print('Without Internet');
        getFromShared();
      }else{
        lastDateAndTime = result['current']['last_updated'];
        print('lkjulkfdjglkdfgjlkdfgjkldfjgldfjglkjulkfdjglkdfgjlkdfgjkldfjgldfjfjgldfjglkdfLastUpdateURL   $lastDateAndTime');
        if (lastUpdatePref == lastDateAndTime) {
          print("With Internet But");
          getFromShared();
        } else {
          print("With Internet");
          // Set Data in variables to view in screen
          title = result['location']['name'];

          condition = result['current']['condition']['text'];
          String dateAndTime = result['location']['localtime'];
          time = dateAndTime.substring(10);
          date = dateAndTime.substring(0, 10);

          if (time.substring(1, 2) == ":") {
            if (int.parse(time.substring(0, 1)) == 0) {
              int hours = int.parse(time.substring(0, 1)) + 1;
              String minutes = time.substring(2);
              time = '$hours$minutes AM';
            }
            time = '$time AM';
            print(":");
          } else if (int.parse(time.substring(0, 3)) >= 12) {
            int hours = int.parse(time.substring(0, 3)) - 12;
            String minutes = time.substring(3);
            time = '$hours$minutes PM';
          } else if (int.parse(time.substring(0, 3)) < 12) {
            time = '$time AM';
          }

          lastDateAndTime = result['current']['last_updated'];
          lastUpdate = lastDateAndTime.substring(10);

          if (int.parse(lastUpdate.substring(0, 3)) >= 12) {
            int hours = int.parse(lastUpdate.substring(0, 3)) - 12;
            String minutes = lastUpdate.substring(3);
            lastUpdate = '$hours$minutes PM';
          } else if (int.parse(lastUpdate.substring(0, 3)) < 12) {
            lastUpdate = '$lastUpdate AM';
          }

          iconUrl = "https:${result['current']['condition']['icon']}";
          temp = (result['current']['temp_c']).round();

          fahrenheit = (result['current']['temp_f']).round();
          visibility = (result['current']['vis_km']).round();
          humidity = (result['current']['humidity']).round();
          pressure = result['current']['pressure_in'];
          cloud = (result['current']['cloud']).round();
          windSpeed = result['current']['wind_kph'];
          uv = (result['current']['uv']).round();
          windDirection = '${result['current']['wind_dir']}';

          _preferencesTest.setSortingOrder("title", title);
        _preferencesTest.setSortingOrder("condition", condition);
        _preferencesTest.setSortingOrder("time", time);
        _preferencesTest.setSortingOrder("date", date);
        _preferencesTest.setSortingOrder("lastDateAndTime", lastDateAndTime);
        _preferencesTest.setSortingOrder("lastUpdate", lastUpdate);
        _preferencesTest.setSortingOrder("iconUrl", iconUrl);
        _preferencesTest.setInt("temp", temp);
        _preferencesTest.setInt("fahrenheit", fahrenheit);
        _preferencesTest.setInt("visibility", visibility);
        _preferencesTest.setInt("humidity", humidity);
        _preferencesTest.setDouble("pressure", pressure);
        _preferencesTest.setInt("cloud", cloud);
        _preferencesTest.setDouble("windSpeed", windSpeed);
        _preferencesTest.setInt("uv", uv);
        _preferencesTest.setSortingOrder("windDirection", windDirection);

        }
      }
    });
    print('dkjfsdiojuksdlfjksdljfjsdfkljsdfjCheck $check');
    print('fkjdsfklhsdfjsdhkjfhsdkjfhksdhfsdjsdfjklTitle  ${await _preferencesTest.getSortingOrder("title")}');
    print('fkjdsfklhsdfjsdhkjfhsdkjfhksdhfsdjsdfjklwindDirection  ${await _preferencesTest.getSortingOrder("iconUrl")}');

  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Scaffold(
              appBar: AppBar(
                title: Text("More Details"),
                centerTitle: true,
                backgroundColor: Colors.teal,
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new ContainerWidgetWeather(
                          width: width,
                          title: "Fahrenheit",
                          subtitle: '$fahrenheit',
                          img: Image.asset(
                            "imgs/Fahrenheit.png",
                            width: 30.0,
                            height: 30.0,
                          )),
                      new ContainerWidgetWeather(
                          width: width,
                          title: "Visibility",
                          subtitle: '$visibility km',
                          img: Image.asset(
                            "imgs/visibility.png",
                            width: 30.0,
                            height: 30.0,
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new ContainerWidgetWeather(
                          width: width,
                          title: "Humidity",
                          subtitle: '$humidity %',
                          img: Image.asset(
                            "imgs/humidity.png",
                            width: 30.0,
                            height: 30.0,
                          )),
                      new ContainerWidgetWeather(
                          width: width,
                          title: "Pressure",
                          subtitle: '$pressure',
                          img: Image.asset(
                            "imgs/pressure.png",
                            width: 30.0,
                            height: 30.0,
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new ContainerWidgetWeather(
                          width: width,
                          title: "Cloud cover",
                          subtitle: '$cloud %',
                          img: Image.asset(
                            "imgs/cloud.png",
                            width: 30.0,
                            height: 30.0,
                          )),
                      new ContainerWidgetWeather(
                          width: width,
                          title: "Wind speed",
                          subtitle: '$windSpeed km/h',
                          img: Image.asset(
                            "imgs/wind_speed.png",
                            width: 30.0,
                            height: 30.0,
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new ContainerWidgetWeather(
                          width: width,
                          title: "UV index",
                          subtitle: '$uv',
                          img: Image.asset(
                            "imgs/uv.png",
                            width: 30.0,
                            height: 30.0,
                          )),
                      new ContainerWidgetWeather(
                          width: width,
                          title: "Wind direction",
                          subtitle: '$windDirection',
                          img: Image.asset(
                            "imgs/wind_direction.png",
                            width: 30.0,
                            height: 30.0,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
  onHomePressed() {
    setState(() {
      print("Home Clicked!");
      _showBottomSheet();
    });
  }
  settingHandler() {
    setState(() {
      print("Settings Clicked!");
    });
  }
  moreHandler() {
    setState(() {
      print("More Clicked!");
    });
  }
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
//    if(check)
    _getWeatherData();
    //initiateVariables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Weather app"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.home), onPressed: onHomePressed)
          ],
        ),
        body: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(
                    'imgs/bg.jpg',
                    fit: BoxFit.fill,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.unfold_more),
                              onPressed: moreHandler,
                              color: Colors.white,
                            ),
                            Text(
                              '$title',
                              style: TextStyle(color: Colors.white),
                            ),
                            IconButton(
                              icon: Icon(Icons.settings),
                              onPressed: settingHandler,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            check? Image.network(
                              iconUrl,
                              fit: BoxFit.fill,
                              height: 120.0,
                              width: 120.0,
                            ) : Text(""),
                            Padding(
                              padding: const EdgeInsets.only(right: 37.0),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('$time',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25.0)),
                                Text('$date',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25.0)),
                                Text('$condition',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25.0)),
                              ],
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Stack(
                              alignment: Alignment(-2.0, 1.2),
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${temp}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 100.0),
                                    ),
                                    Image.asset(
                                      "imgs/celsius2.png",
                                      width: 100.0,
                                      height: 100.0,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                Text(
                                  "Last update: $lastUpdate",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                        ),
                        //TODO Under Degree: Show some details
                        InkWell(
                          onTap: _showBottomSheet,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  new HomeSomeDetails(
                                    title: ' $fahrenheit',
                                    img: Image.asset(
                                      "imgs/Fahrenheit.png",
                                      width: 30.0,
                                      height: 30.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  new HomeSomeDetails(
                                    title: ' ${humidity} %',
                                    img: Image.asset(
                                      "imgs/humidity.png",
                                      width: 30.0,
                                      height: 30.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  new HomeSomeDetails(
                                    title: ' $visibility km',
                                    img: Image.asset(
                                      "imgs/visibility.png",
                                      width: 30.0,
                                      height: 30.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 35.0)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  new HomeSomeDetails(
                                    title: ' $cloud %',
                                    img: Image.asset(
                                      "imgs/cloud.png",
                                      width: 30.0,
                                      height: 30.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  new HomeSomeDetails(
                                    title: ' $windDirection',
                                    img: Image.asset(
                                      "imgs/wind_direction.png",
                                      width: 30.0,
                                      height: 30.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  new HomeSomeDetails(
                                    title: ' $uv',
                                    img: Image.asset(
                                      "imgs/uv.png",
                                      width: 30.0,
                                      height: 30.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class HomeSomeDetails extends StatelessWidget {
  const HomeSomeDetails({Key key, @required this.title, this.img})
      : super(key: key);

  final String title;
  final Image img;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        img,
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      ],
    );
  }
}

class ContainerWidgetWeather extends StatelessWidget {
  const ContainerWidgetWeather(
      {Key key, @required this.width, this.title, this.subtitle, this.img})
      : super(key: key);

  final double width;
  final String title, subtitle;
  final Image img;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (width / 2) - 20.0,
      color: Colors.grey.shade200,
      padding: const EdgeInsets.all(7.0),
      child: Row(
        children: <Widget>[
          img,
          Padding(padding: const EdgeInsets.only(right: 12.0)),
          Column(
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(subtitle)
            ],
          )
        ],
      ),
    );
  }
}
