
import 'package:flutter/material.dart';

import 'flutter-instagram-clone/screens/FrontScreen.dart';

void main(){
 
  runApp(MyApp());
  
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: FrontScreen(),
      theme: ThemeData(
        backgroundColor: Color(0xfff9f9f9),
        accentColor: Color(0xff22262f),
        primaryColor: Color(0xff0c8eff),
        ),
    );
    
  }
}