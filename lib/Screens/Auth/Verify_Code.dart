import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_r1/Screens/Realtime%20Database/Home_Screen.dart';
import 'package:firebase_r1/Widgets/Round_Button.dart';
import 'package:firebase_r1/Widgets/Utils.dart';
import 'package:flutter/material.dart';

class Verify_Code extends StatefulWidget {
  final String verificationId;
  const Verify_Code({super.key, required this.verificationId});

  @override
  State<Verify_Code> createState() => _Verify_CodeState();
}

class _Verify_CodeState extends State<Verify_Code> {

  final codeController = TextEditingController();
  bool loading = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        title: Text("Verify",style: TextStyle(
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
              controller: codeController,
              validator: (code) {
                if(code!.isEmpty){
                  return "Enter Code";
                }
                if(code.length < 6) {
                  return "Enter Valid Code";
                }
                return null;
              },
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  prefixIcon: Icon(Icons.lock),
                  labelText: "Enter Code",
              ),
            ),
          ),
          SizedBox(height: 40),
          Round_Button(
            title: "Verify",
            loading: loading,
            onTap: () async {
              setState(() {
                loading = true;
              });
              final credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: codeController.text
              );
              try{

                await _auth.signInWithCredential(credential);
                setState(() {
                  loading = false;
                });
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Home_Screen() ));

              }catch(e){
                setState(() {
                  loading = false;
                });
                Utils().toastMessage("Enter Valid Code");
              }
            },
          )
        ],
      ),
    );
  }
}
