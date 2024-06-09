import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_r1/Screens/Auth/Login_Screen.dart';
import 'package:firebase_r1/Widgets/Round_Button.dart';
import 'package:firebase_r1/Widgets/Utils.dart';
import 'package:flutter/material.dart';

class Signup_Screen extends StatefulWidget {
  const Signup_Screen({super.key});

  @override
  State<Signup_Screen> createState() => _Signup_ScreenState();
}

class _Signup_ScreenState extends State<Signup_Screen> {

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final nameController  = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void clearText(){
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  FirebaseAuth _auth = FirebaseAuth.instance; // Authentication Instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 200),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sign Up",style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),)
                  ],
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (name) {
                      if(name!.isEmpty){
                        return "Enter Name";
                      }
                      return null;
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Enter Name"
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    controller: emailController,
                    validator: (email) {
                      if(email!.isEmpty){
                        return "Enter Email";
                      }
                      if(!email.endsWith('@gmail.com')) {
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
                        labelText: "Enter Email"
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (password) {
                      if(password!.isEmpty){
                        return "Enter Password";
                      }
                      if(password.length < 6){
                        return "6 Digits Needed";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        prefixIcon: Icon(Icons.password),
                        labelText: "Enter Password"
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Round_Button(
                  title: "Sign Up",
                  loading: loading,
                  onTap: () {
                    if(_formKey.currentState!.validate()){
                      setState(() {
                        loading = true;
                      });
                      _auth.createUserWithEmailAndPassword(
                          email: emailController.text.toString(),
                          password: passwordController.text.toString())
                          .then((value) {
                        setState(() {
                          loading = false;
                          clearText();
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Login_Screen() ));
                          });
                        }).onError((error, stackTrace) {
                        setState(() {
                          loading = false;
                        });
                        Utils().toastMessage("This Account is Already Exists");
                      });
                    }
                  },
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an Account !!",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),),
                    TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                              builder: (context) => Login_Screen()),
                              (route) => route.isFirst
                          );
                        },
                        child: Text("Login",style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple
                        ),)
                    )
                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}
