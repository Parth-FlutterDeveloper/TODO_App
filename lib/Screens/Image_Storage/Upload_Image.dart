import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_r1/Widgets/Round_Button.dart';
import 'package:firebase_r1/Widgets/Utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Upload_Image extends StatefulWidget {
  const Upload_Image({super.key});

  @override
  State<Upload_Image> createState() => _Upload_ImageState();
}

class _Upload_ImageState extends State<Upload_Image> {

  bool loading = false;
  var newURL;

  File? _file; // file variable
  final _picker = ImagePicker(); // image picker variable
  FirebaseStorage storage = FirebaseStorage.instance; // Storage instance

  DatabaseReference dataRef = FirebaseDatabase.instance.ref('Post'); // realtime database reference


  Future getGalleryImage() async {

    final pickedImage = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if(pickedImage != null){
        _file = File(pickedImage.path);
        Utils().toastMessage("Image Selected");
      }else{
        Utils().toastMessage("No Image Selected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        title: Text("Upload Image",style: TextStyle(
          fontSize: 26,
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
        backgroundColor: Colors.purple,
      ),


      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getGalleryImage();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: _file != null
                      ? Image.file(_file!.absolute)
                      : Icon(Icons.image),
                ),
              ),
            ),

            SizedBox(height: 40),

            Round_Button(
                title: "Upload",
                loading: loading,
                onTap: () async {
                  if(_file != null){

                    setState(() {
                      loading = true;
                    });
                    var id = DateTime.now().millisecondsSinceEpoch.toString();

                    Reference ref = FirebaseStorage.instance.ref('/Images/'+id);
                    UploadTask uploadTask = ref.putFile(_file!.absolute); // for image url

                    await Future.value(uploadTask);
                    newURL = await ref.getDownloadURL();

                    // dataRef.child(id).set({ // to add image in realtime database
                    //   'Id': id,
                    //   'Text': newURL.toString()
                    // });

                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage("Image Uploaded");
                  }else{
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage("Please Select a Image");
                  }
                },
            ),
          ],
        ),
      ),
    );
  }
}
