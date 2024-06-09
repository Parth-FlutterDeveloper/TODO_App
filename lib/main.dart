import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_r1/Widgets/Splash_Screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyFireBaseApp());
}

class MyFireBaseApp extends StatefulWidget {
  const MyFireBaseApp({super.key});

  @override
  State<MyFireBaseApp> createState() => _MyFireBaseAppState();
}

class _MyFireBaseAppState extends State<MyFireBaseApp> {

final Future<FirebaseApp> _initialization =Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot){
          if(snapshot.hasError){
            print("Somethings Went Wrong");
          }
          if(snapshot.connectionState == ConnectionState.done){
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Splash_Screen(),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }
    );
  }
}
