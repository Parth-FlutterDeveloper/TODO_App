import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_r1/Screens/Firebase%20Firestore/List_Screen.dart';
import 'package:firebase_r1/Widgets/Round_Button.dart';
import 'package:firebase_r1/Widgets/Utils.dart';
import 'package:flutter/material.dart';

class Add_Element extends StatefulWidget {
  const Add_Element({super.key});

  @override
  State<Add_Element> createState() => _Add_ElementState();
}

class _Add_ElementState extends State<Add_Element> {

  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        title: Text("Add Post",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white
          ),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 110),

          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: TextFormField(
                maxLines: 4,
                validator: (text) {
                  if(text!.isEmpty){
                    return "Please Enter Some Text";
                  }
                  return null;
                },
                controller: textController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    hintText: "Please Enter Your Name !!!"
                ),
              ),
            ),
          ),

          SizedBox(height: 40),

          Round_Button(
              title: "Add",
              onTap: () {
                if(_formKey.currentState!.validate()){

                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  fireStore.doc(id).set({

                    'title': textController.text,
                    'id' : id

                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage("User Added");
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => List_Screen() ));

                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage("Somethings Went Wrong");
                  });

                }
              },
              loading: loading
          )
        ],
      ),
    );
  }
}
