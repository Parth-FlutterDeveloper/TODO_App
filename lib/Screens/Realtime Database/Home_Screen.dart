import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_r1/Screens/Image_Storage/Upload_Image.dart';
import 'package:firebase_r1/Screens/Realtime%20Database/Add_Posts.dart';
import 'package:firebase_r1/Screens/Auth/Login_Screen.dart';
import 'package:firebase_r1/Widgets/Utils.dart';
import 'package:flutter/material.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        title: Text("List",
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
            builder: (context) => Add_Posts() ));
        },
        shape: CircleBorder(),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),


      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 26),


          // Expanded(
          //     child: StreamBuilder(
          //       stream: ref.onValue,
          //       builder: (context, AsyncSnapshot<DatabaseEvent> snapshot){
          //         if(!snapshot.hasData){
          //           return Center(
          //             child: CircularProgressIndicator(color: Colors.purple),
          //           );
          //         }else {
          //
          //           Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
          //           List<dynamic> list = [];
          //           list.clear();
          //           list = map.values.toList();
          //
          //           return ListView.builder(
          //               itemCount: snapshot.data!.snapshot.children.length,
          //               itemBuilder: (context, index){
          //                 return ListTile(
          //                   title: Text(list[index]['Text'],
          //                     style: TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       fontSize: 21,
          //                     ),),
          //                   subtitle: Text(list[index]['Id'],
          //                     style: TextStyle(
          //                         fontSize: 15,
          //                         color: Colors.purple
          //                     ),),
          //                 );
          //               }
          //           );
          //         }
          //       },
          //     )
          // ),


          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: TextFormField(
              controller: searchFilter,
              onChanged: (String value){
                setState(() {

                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Search Here..."
              ),
            ),
          ),

          SizedBox(height: 10),

          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                itemBuilder: (context, snapshot, animation, index){

                  final title = snapshot.child('Text').value.toString();

                  if(searchFilter.text.isEmpty){
                    return  ListTile(
                      title: Text(snapshot.child('Text').value.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                        ),),
                      subtitle: Text(snapshot.child('Id').value.toString(),style: TextStyle(
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
                            child: ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                showMyDialog(title, snapshot.child('Id').value.toString());
                              },
                              leading: Icon(Icons.edit,color: Colors.purple,),
                              title: Text("Edit",style: TextStyle(
                                fontSize: 16,
                                color: Colors.purple
                              ),),
                            ),
                          ),
                          PopupMenuItem(
                            value: 1,
                            onTap: () {
                              ref.child(snapshot.child('Id').value.toString()).remove().
                              then((value) {
                                Utils().toastMessage("User Deleted");
                              }).
                              onError((error, stackTrace) {
                                Utils().toastMessage("User Can't Delete");
                              });
                            },
                            child: ListTile(
                              leading: Icon(Icons.delete,color: Colors.red,),
                              title: Text("Delete",style: TextStyle(
                                fontSize: 16,
                                color: Colors.red
                              ),),
                            ),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => Upload_Image()
                                ));
                              },
                              leading: Icon(Icons.image,color: Colors.purple,),
                              title: Text("Image",style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.purple
                              ),),
                            ),
                          ),
                        ],
                      ),
                    );
                  }else if(title.toLowerCase().contains(searchFilter.text.toLowerCase().toLowerCase())){
                    return  ListTile(
                      title: Text(snapshot.child('Text').value.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                        ),),
                      subtitle: Text(snapshot.child('Id').value.toString(),style: TextStyle(
                          fontSize: 15,
                          color: Colors.purple
                      ),),
                    );
                  }else{
                    return Container();
                  }
                },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editText.text = title;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                  onPressed: () {
                    ref.child(id).update({
                      'Text': editText.text
                    }).then((value) {
                      Navigator.pop(context);
                      Utils().toastMessage("User Updated");
                    }).onError((error, stackTrace) {
                      Navigator.pop(context);
                      Utils().toastMessage("Can't Update");
                    });
                    Navigator.pop(context);
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
            content: Container(
              child: TextFormField(
                controller: editText,
                decoration: InputDecoration(
                  hintText: "Update Here..."
                ),
              ),
            ),
          );
        }
    );
  }

}
