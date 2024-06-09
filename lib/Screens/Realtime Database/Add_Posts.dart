import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_r1/Screens/Realtime%20Database/Home_Screen.dart';
import 'package:firebase_r1/Widgets/Round_Button.dart';
import 'package:firebase_r1/Widgets/Utils.dart';
import 'package:flutter/material.dart';

class Add_Posts extends StatefulWidget {
  const Add_Posts({super.key});

  @override
  State<Add_Posts> createState() => _Add_PostsState();
}

class _Add_PostsState extends State<Add_Posts> {

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Post');

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
                  hintText: "Please Enter Your Name !"
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

                  databaseRef.child(id).set({
                    'Id' : id,
                    'Text' : textController.text
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage("Successfully Added");
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Home_Screen() ));
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage("Somethings Went Wrong");
                  });
                }
              },
              loading: loading
          ),
        ],
      ),
    );
  }
}
