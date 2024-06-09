import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_r1/Widgets/Round_Button.dart';
import 'package:firebase_r1/Widgets/Utils.dart';
import 'package:firebase_r1/Screens/Auth/Verify_Code.dart';
import 'package:flutter/material.dart';

class Phone_Login extends StatefulWidget {
  const Phone_Login({super.key});

  @override
  State<Phone_Login> createState() => _Phone_LoginState();
}

class _Phone_LoginState extends State<Phone_Login> {

  final phoneController = TextEditingController();
  bool loading = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        title: Text("Login",style: TextStyle(
          fontSize: 27,
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
              controller: phoneController,
              validator: (phone) {
                if(phone!.isEmpty){
                  return "Enter Phone Number";
                }
                if(phone.length < 10) {
                  return "Enter Valid Phone Number";
                }
                return null;
              },
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  prefixIcon: Icon(Icons.phone),
                  labelText: "Phone Number",
                // prefixText: "+91 ",
              ),
            ),
          ),
          SizedBox(height: 40),
          Round_Button(
              title: "Login",
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                _auth.verifyPhoneNumber(
                  phoneNumber: phoneController.text,
                    verificationCompleted: (context) {
                      setState(() {
                        loading = false;
                      });
                    },
                    verificationFailed: (e) {
                      Utils().toastMessage("Enter Valid Phone Number OR \n Try Letter");
                      setState(() {
                        loading = false;
                      });
                    },
                    codeSent: (String verificationId, int? token) {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Verify_Code(verificationId: verificationId,) ));
                      setState(() {
                        loading = false;
                      });
                    },
                    codeAutoRetrievalTimeout: (e) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage("Something Went Wrong");
                    }
                );
              },
          )
        ],
      ),
    );
  }
}
