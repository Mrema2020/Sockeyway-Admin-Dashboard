import 'dart:html' as html;
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sockeyway_web/utils/colors.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _descriptionController = TextEditingController();
 String?_image;
  bool isLoading = false;


  Future<void> _pickImage() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final file = uploadInput.files!.first;
      final reader = html.FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((e) {
        setState(() {
          _image = reader.result as String?;
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post',
            style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 18,
              fontWeight: FontWeight.bold
            )
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 800,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_image != null) ...[
                    Image.network(_image!),
                    const SizedBox(height: 16.0),
                  ],
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: TextButton(
                      onPressed: _pickImage,
                      child: const Text('Pick Image',
                          style: TextStyle(
                              color: AppColors.textColor
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                        labelText: 'Caption',

                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: TextButton(
                      onPressed: (){
                        setState(() {
                          isLoading = true;
                        });
                        _validate();
                      },
                      child: isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.textColor,))
                      : const Text('Post',
                      style: TextStyle(
                        color: AppColors.textColor
                      ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Uint8List> _getImageData(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  void _uploadPost() async {
    if (_image == null || _descriptionController.text.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null) {
      setState(() {
        isLoading = false;
      });
      // Handle user not signed in
      return;
    }

    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference ref = storage.ref().child('posts/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');

    try {
      final Uint8List imageData = await _getImageData(_image!);
      final UploadTask uploadTask = ref.putData(imageData);
      await uploadTask.whenComplete(() => null);
      final String downloadURL = await ref.getDownloadURL();

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('posts').add({
        'imageUrl': downloadURL,
        'description': _descriptionController.text,
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear input fields
      setState(() {
        _image = null;
        _descriptionController.clear();
        isLoading = false;
      });

      // Display success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Post uploaded successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error uploading post: $e');
      setState(() {
        isLoading = false;
      });
      // Display error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to upload post. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  _validate(){
    if(_image == null){
      setState(() {
        isLoading = false;
      });
      Flushbar(
        title:  "Image missing",
        message:  "Please pick image to continue",
        duration:  const Duration(seconds: 3),
        backgroundColor: const Color(0Xffc71f37).withOpacity(0.5),
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(Icons.warning,
          color: Colors.white,
        ),
      ).show(context);
    }else if(_descriptionController.text.trim() == ""){
      setState(() {
        isLoading = false;
      });
      Flushbar(
        title:  "Description missing",
        message:  "Please provide news description",
        duration:  const Duration(seconds: 3),
        backgroundColor: const Color(0Xffc71f37).withOpacity(0.5),
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(Icons.warning,
          color: Colors.white,
        ),
      ).show(context);
    }else{
      _uploadPost();
    }
  }

}