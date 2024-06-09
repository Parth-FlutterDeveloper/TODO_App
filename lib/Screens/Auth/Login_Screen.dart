import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_r1/Screens/Auth/Forgot_Screen.dart';
import 'package:firebase_r1/Screens/Realtime%20Database/Home_Screen.dart';
import 'package:firebase_r1/Screens/Auth/Phone_Login.dart';
import 'package:firebase_r1/Screens/Auth/Signup_Screen.dart';
import 'package:firebase_r1/Widgets/Round_Button.dart';
import 'package:firebase_r1/Widgets/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  void clearText(){
    emailController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 170),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Login",style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),)
                  ],
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
                SizedBox(height: 40),
                Round_Button(
                  loading: loading,
                  title: "Login",
                  onTap: () {
                    if(_formKey.currentState!.validate()){
                      setState(() {
                        loading = true;
                      });
                      _auth.signInWithEmailAndPassword(
                          email: emailController.text.toString(),
                          password: passwordController.text.toString()
                      ).then((value) {
                        setState(() {
                          loading = false;
                          clearText();
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Home_Screen() ));
                        });
                      }).onError((error, stackTrace) {
                        setState(() {
                          loading = false;
                        });
                        Utils().toastMessage("Please Check Email & Password");
                      });
                    }
                  },
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Forgot_Screen()));
                    },
                    child: Text("Forgot Password ?",style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple
                    ),)
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("OR",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),)
                  ],
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Phone_Login() ));
                  },
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purple,width: 3),
                      borderRadius: BorderRadius.circular(27)
                    ),
                    child: Center(
                      child: Text("Login With Phone",style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                  ),
                ),
                SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an Account !!",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Signup_Screen()));
                        },
                        child: Text("Sign Up",style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple
                        ),)
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
