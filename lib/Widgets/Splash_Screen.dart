import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_r1/Screens/Realtime%20Database/Home_Screen.dart';
import 'package:firebase_r1/Screens/Auth/Login_Screen.dart';
import 'package:flutter/material.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {

  @override
  void initState() {
    super.initState();

    FirebaseAuth _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;

    if(user != null){
      Timer(Duration(seconds: 3), () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => Home_Screen()
        ),(route) => route.isFirst);
      });
    }else{
      Timer(Duration(seconds: 3), () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => Login_Screen()
        ),(route) => route.isFirst);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Page Loading...",style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.purple
            ),),
            SizedBox(height: 23),
            CircularProgressIndicator(
              color: Colors.purple,
            )
          ],
        ),
      ),
    );
  }
}
