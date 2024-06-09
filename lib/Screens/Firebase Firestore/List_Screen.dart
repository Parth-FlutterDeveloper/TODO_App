import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_r1/Screens/Auth/Login_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_r1/Screens/Firebase%20Firestore/Add_Element.dart';
import 'package:firebase_r1/Widgets/Utils.dart';
import 'package:flutter/material.dart';

class List_Screen extends StatefulWidget {
  const List_Screen({super.key});

  @override
  State<List_Screen> createState() => _List_ScreenState();
}

class _List_ScreenState extends State<List_Screen> {

  final editText = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();

  CollectionReference ref = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        title: Text("Post",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 27,
              color: Colors.white
          ),),
        actions: [
          IconButton(
              onPressed: () {
                _auth.signOut().then((value) {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Login_Screen()
                  ));
                });
              },
              icon: Icon(Icons.logout)
          ),
          SizedBox(width: 7),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => Add_Element() ));
        },
        shape: CircleBorder(),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),

          StreamBuilder <QuerySnapshot>(
              stream: fireStore,
              builder: (BuildContext context, AsyncSnapshot <QuerySnapshot> snapshot) {

                if(snapshot.hasError){
                  return Text("Something Went Wrong");
                }

                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(color: Colors.purple,),
                  );
                }

                return  Expanded(
                  child: ListView.builder(

                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index){

                        String title = snapshot.data!.docs[index]['title'].toString();

                        return ListTile(
                          title: Text(snapshot.data!.docs[index]['title'].toString(),style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                          ),),
                          subtitle: Text(snapshot.data!.docs[index]['id'].toString(),style: TextStyle(
                              fontSize: 15,
                              color: Colors.purple
                          ),),
                         trailing: PopupMenuButton(
                           color: Colors.white,
                           elevation: 2,
                           icon: Icon(Icons.more_vert),
                           itemBuilder: (context) => [
                             PopupMenuItem(
                               value: 1,
                               onTap: () {
                                 // Navigator.pop(context);
                                 showMyDialog(title,snapshot.data!.docs[index]['id'].toString());
                               },
                               child: ListTile(
                                 title: Text("Edit",style: TextStyle(
                                   color: Colors.purple,
                                   fontSize: 16
                                 ),),
                                 leading: Icon(Icons.edit,color: Colors.purple,),
                               ),
                             ),
                             PopupMenuItem(
                               value: 1,
                               onTap: () {
                                 ref.doc(snapshot.data!.docs[index]['id'].toString()).delete()
                                     .then((value) {
                                     Utils().toastMessage("User Deleted");
                                 })
                                 .onError((error, stackTrace) {
                                   Utils().toastMessage("User Can't Deleted");
                                 });
                               },
                               child: ListTile(
                                 title: Text("Delete",style: TextStyle(
                                     color: Colors.red,
                                     fontSize: 16
                                 ),),
                                 leading: Icon(Icons.delete,color: Colors.red,),
                               ),
                             ),
                           ],
                         ),
                        );
                      },
                  ),
                );
              }
          ),
        ],
      ),

    );
  }

  Future<void> showMyDialog(String title, String id) async {
    final _formKey = GlobalKey<FormState>();
    editText.text = title;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()){

                      ref.doc(id).update({
                        'title': editText.text
                      }).then((value) {
                        Navigator.pop(context);
                        Utils().toastMessage("User Updated");
                      }).onError((error, stackTrace) {
                        Navigator.pop(context);
                        Utils().toastMessage("Can't Update");
                      });

                    }
                  },
                  child: Text("Update",style: TextStyle(
                      fontSize: 18,
                      color: Colors.purple
                  ),)
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel",style: TextStyle(
                      fontSize: 18,
                      color: Colors.purple
                  ),)
              ),
            ],
            title: Text("Update",style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.purple
            ),),
            content: Form(
              key: _formKey,
              child: Container(
                child: TextFormField(
                  validator: (text) {
                    if(text!.isEmpty){
                      return "Please Enter Text";
                    }
                    return null;
                  },
                  controller: editText,
                  decoration: InputDecoration(
                      hintText: "Update Here..."
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

}
