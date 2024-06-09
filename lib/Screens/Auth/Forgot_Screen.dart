import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_r1/Widgets/Round_Button.dart';
import 'package:firebase_r1/Widgets/Utils.dart';
import 'package:flutter/material.dart';

class Forgot_Screen extends StatefulWidget {
  const Forgot_Screen({super.key});

  @override
  State<Forgot_Screen> createState() => _Forgot_ScreenState();
}

class _Forgot_ScreenState extends State<Forgot_Screen> {

  final emailController = TextEditingController();
  bool loading = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        title: Text("Forgot  Password",style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              controller: emailController,
              validator: (email) {
                if(email!.isEmpty){
                  return "Enter Email";
                }
                if(!email.contains('@')) {
                  return "Enter Valid Email";
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  prefixIcon: Icon(Icons.email),
                  labelText: "Enter Email",
              ),
            ),
          ),
          SizedBox(height: 30),
          Round_Button(
            title: "Forgot",
            loading: loading,
            onTap: () {
              setState(() {
                loading = true;
              });
              _auth.sendPasswordResetEmail(
                  email: emailController.text
              ).then((value) {
                setState(() {
                  loading = false;
                });
                Utils().toastMessage("Link Sent to Your Email Box, Please Check Your Email");
              })
              .onError((error, stackTrace) {
                setState(() {
                  loading = false;
                });
                Utils().toastMessage("Something Went Wrong");
              });
            },
          )
        ],
      ),
    );
  }
}
