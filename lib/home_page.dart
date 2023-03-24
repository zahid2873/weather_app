import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';


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
     var weather = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=${position!.latitude}&lon=${position!.longitude}&appid=85d48725d65c4de60fa682a3d0194b21&units=metric"));
     print("${weather.body}");
     var forecast = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/forecast?lat=${position!.latitude}&lon=${position!.longitude}&appid=85d48725d65c4de60fa682a3d0194b21&units=metric"));
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
      backgroundColor: Colors.black.withOpacity(.2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [

            Expanded(
                flex:7,
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width:double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbYLXIcdlE70TFiSrXD8p9VeJb9q9F3qoIIBULicbXNkdrTT7FEwXtxspStmqG2lAPG5o&usqp=CAU"),fit: BoxFit.cover),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30,),topLeft: Radius.circular(30),bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30))
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on,color: Colors.white70,),
                                Text("${weatherMap!["name"]}, ${weatherMap!["sys"]["country"]}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),),
                              ],
                            ),
                            Row(
                              children: [
                                //Icon(Icons.location_on,color: Colors.white70,),
                                Text("${Jiffy("${DateTime.now()}").format('MMM do yyyy')}, ${Jiffy("${DateTime.now()}").format('hh mm')}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white)),                                //Text("${weatherMap!["name"]}, ${weatherMap!["sys"]["country"]}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*.1-40,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            height: 80,width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue.withOpacity(.2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Min",style: TextStyle(fontSize: 16,color:Colors.white)),
                              Text("${weatherMap!["main"]["temp_min"]}°",style: TextStyle(fontSize: 18,color:Colors.white),)
                            ],
                          ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height*.2-20,
                            width: MediaQuery.of(context).size.width*.5+20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.blue.withOpacity(.2),

                            ),
                            child: Row(
                              children: [
                                Image.network("https://openweathermap.org/img/wn/${weatherMap!["weather"][0]["icon"]}@2x.png"),
                                Text("${weatherMap!["main"]["temp"]}°",style: TextStyle(fontSize: 34,fontWeight: FontWeight.w800,color: Colors.white.withOpacity(.7))),
                              ],
                            ),
                          ),
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue.withOpacity(.2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Max",style: TextStyle(fontSize: 16,color:Colors.white)),
                                Text("${weatherMap!["main"]["temp_max"]}°",style: TextStyle(fontSize: 18,color:Colors.white),)
                              ],
                            ),
                          ),

                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Wind",style: TextStyle(fontSize: 16,color: Colors.white),),
                                      Row(
                                        children: [
                                          Text("${weatherMap!["wind"]["speed"]}",style: TextStyle(fontSize: 26,color: Colors.white,fontWeight: FontWeight.bold)),
                                        Text("km",style: TextStyle(color:Colors.white),)
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Humidity",style: TextStyle(fontSize: 16,color: Colors.white),),
                                      Row(
                                        children: [
                                          Text("${weatherMap!["main"]["humidity"]}",style: TextStyle(fontSize: 26,color: Colors.white,fontWeight: FontWeight.bold)),
                                          Text("%",style: TextStyle(color:Colors.white),)
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Pressure",style: TextStyle(fontSize: 16,color: Colors.white),),
                                      Row(
                                        children: [
                                          Text("${weatherMap!["main"]["pressure"]}",style: TextStyle(fontSize: 26,color: Colors.white,fontWeight: FontWeight.bold)),
                                          //Text("",style: TextStyle(color:Colors.white),)
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Feels Like: ${weatherMap!["main"]["feels_like"]}°",style: TextStyle(fontSize: 18,color:Colors.white),),
                                Text("${weatherMap!["weather"][0]["description"]}",style: TextStyle(fontSize: 18,color:Colors.white),),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Sunset : ${Jiffy("${DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunrise"] * 1000)}").format("hh mm a")}",style: TextStyle(fontSize: 18,color:Colors.white),),
                                Text("Sunset : ${Jiffy("${DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunset"] * 1000)}").format("hh mm a")}",style: TextStyle(fontSize: 18,color:Colors.white),),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),

                )),
            Expanded(flex:5,child: Container(
                width:double.infinity,
            decoration:  BoxDecoration(
                color:  Colors.red,
                image: DecorationImage(image: NetworkImage("https://wallpaperaccess.com/full/386720.jpg"),fit: BoxFit.cover),
                borderRadius: BorderRadius.only(topRight: Radius.circular(20,),topLeft: Radius.circular(20),bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))
            ),
              child: ListView.builder(
                shrinkWrap: true,
                  itemCount: forecastMap!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index)=>Container(
                    width: 150,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(right: 15,left: 10,top: 10,bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(.2),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      children: [
                        Text("${Jiffy("${forecastMap!["list"][index]["dt_txt"]}").format("EEE h mm")}",style: TextStyle(fontSize: 16,color:Colors.white),),
                        Image.network("https://openweathermap.org/img/wn/${forecastMap!["list"][index]["weather"][0]["icon"]}@2x.png"),
                        Text("${forecastMap!["list"][index]["main"]["temp"]}°",style: TextStyle(fontSize: 26,fontWeight: FontWeight.w800,color: Colors.white.withOpacity(.7))),
                        Text("${forecastMap!["list"][index]["weather"][0]["description"]}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w800,color: Colors.white.withOpacity(.7))),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Wind",style: TextStyle(fontSize: 14,color: Colors.white),),
                                Text("${forecastMap!["list"][index]["wind"]["speed"]}",style: TextStyle(fontSize: 16,color:Colors.white),),
                                //Text("${forecastMap!["weather"][0]["description"]}",style: TextStyle(fontSize: 14,color:Colors.white),),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Humidity",style: TextStyle(fontSize: 14,color: Colors.white),),
                                Text("${forecastMap!["list"][index]["main"]["humidity"]}",style: TextStyle(fontSize: 16,color:Colors.white),),
                              ],
                            ),

                          ],
                        ),
                        SizedBox(height: 5,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Sea Lvl",style: TextStyle(fontSize: 14,color: Colors.white),),
                                Text("${forecastMap!["list"][index]["main"]["sea_level"]}",style: TextStyle(fontSize: 16,color:Colors.white),),
                                //Text("${forecastMap!["weather"][0]["description"]}",style: TextStyle(fontSize: 14,color:Colors.white),),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Grand Lvl",style: TextStyle(fontSize: 14,color: Colors.white),),
                                Text("${forecastMap!["list"][index]["main"]["grnd_level"]}",style: TextStyle(fontSize: 16,color:Colors.white),),
                              ],
                            ),

                          ],
                        )

                      ],
                    ),
                  )),
            )),


            //Text("Location: ${weatherMap!["name"]}"),
            //Text("Location: ${weatherMap!["name"]}"),

          ],
        ),
      ),
      ): Center(child: CircularProgressIndicator());

  }
}
