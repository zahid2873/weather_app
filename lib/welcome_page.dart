import 'package:flutter/material.dart';
import 'package:weather_app/home_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(right: 20,left: 20,top: 60),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blue,
          image: DecorationImage(image: NetworkImage("https://static.vecteezy.com/system/resources/previews/001/966/750/non_2x/couple-with-umbrella-under-rain-free-vector.jpg",),fit: BoxFit.cover)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Stay Update About Weather", style: TextStyle(fontSize: 36,fontWeight: FontWeight.w800,color: Colors.black.withOpacity(.7)),),
            Text("Make an uncertain future a little more certain",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black54),),
            SizedBox(height: MediaQuery.of(context).size.height*.4,),
            Container(
              //height: double.infinity,
              height: MediaQuery.of(context).size.height*.3+20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black54.withOpacity(.3),
                borderRadius: BorderRadius.circular(40)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Discover the Weather \n         in Your City",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w800,color: Colors.white.withOpacity(.7))),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height*.1,
                    child: Text("Get to Know your weather and  radar \n            precipitation forecast ",style: TextStyle(fontSize: 16,color: Colors.white.withOpacity(.5))),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: MaterialButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                    },
                      padding: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      minWidth: double.infinity,
                      height: MediaQuery.of(context).size.height*.1-30,

                      color: Colors.white.withOpacity(.2),
                      child: Text("Get Started",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white.withOpacity(.7)),),
                    ),
                  )

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
