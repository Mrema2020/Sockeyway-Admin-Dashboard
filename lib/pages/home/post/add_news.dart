import 'dart:html' as html;
import 'dart:typed_data';


import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../utils/colors.dart';

class AddNews extends StatefulWidget {
  const AddNews({super.key});

  @override
  State<AddNews> createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {

  final TextEditingController _titleController = TextEditingController();
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
        centerTitle: true,
        title: const Text('Add News',
          style: TextStyle(
              color: AppColors.primaryColor,
            fontSize: 18
          ),
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 800,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Description'),
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
                      ? const Center(child: CircularProgressIndicator(color: AppColors.textColor))
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
    if (_image == null || _descriptionController.text.isEmpty || _titleController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Details Missing'),
            content: const Text('Please fill all the details'),
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

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null) {
      // Handle user not signed in
      return;
    }

    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference ref = storage.ref().child('news/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');

    try {
      final Uint8List imageData = await _getImageData(_image!);
      final UploadTask uploadTask = ref.putData(imageData);
      await uploadTask.whenComplete(() => null);
      final String downloadURL = await ref.getDownloadURL();

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('news').add({
        'imageUrl': downloadURL,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear input fields
      setState(() {
        isLoading = false;
        _image = null;
        _titleController.clear();
        _descriptionController.clear();
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
    } else if(_titleController.text.trim() == ""){
      setState(() {
        isLoading = false;
      });
      Flushbar(
        title:  "Title missing",
        message:  "Please provide news title",
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
