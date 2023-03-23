import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    position =  await Geolocator.getCurrentPosition();
    getWeatherData();
    print("long: ${position!.longitude} lati${position!.latitude}");
  }

  Map<String, dynamic> ?weatherMap;
   Map<String, dynamic>? forecastMap;

   getWeatherData()async{
     var weather = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=${position!.latitude}&lon=${position!.longitude}&appid=85d48725d65c4de60fa682a3d0194b21"));
     print("${weather.body}");
     var forecast = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/forecast?lat=${position!.latitude}&lon=${position!.longitude}&appid=85d48725d65c4de60fa682a3d0194b21"));
     print("${forecast.body}");

     var weatherData = jsonDecode(weather.body);
     var forecastData = jsonDecode(forecast.body);

     setState(() {
       weatherMap = Map<String, dynamic>.from(weatherData);
       forecastMap = Map<String, dynamic>.from(forecastData);
     });
    // print("${weatherMap!["name"]}");

   }

  Position ? position;

  @override
  void initState() {
    _determinePosition();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return weatherMap!=null? Scaffold(
      appBar: AppBar(
        title: Text("Weather and Forecast"),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Text("Location: ${weatherMap!["name"]}"),
            //Text("Location: ${weatherMap!["name"]}"),

          ],
        ),
      ),
      ): Center(child: CircularProgressIndicator());

  }
}
