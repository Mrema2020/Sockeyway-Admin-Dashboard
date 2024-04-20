import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class AddMatch extends StatefulWidget {
  const AddMatch({super.key});

  @override
  State<AddMatch> createState() => _AddMatchState();
}

class _AddMatchState extends State<AddMatch> {
  final TextEditingController _homeTeamController = TextEditingController();
  final TextEditingController _awayTeamController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Fixture',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 18,
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
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Select Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        controller: selectedDate != null
                            ? TextEditingController(text: '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}')
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _selectTime(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Select Time',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        controller: selectedTime != null
                            ? TextEditingController(text: '${selectedTime!.hour}:${selectedTime!.minute}')
                            : null,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _homeTeamController,
                    decoration: const InputDecoration(labelText: 'Home Team'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _awayTeamController,
                    decoration: const InputDecoration(labelText: 'Away Team'),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    color: AppColors.primaryColor,
                    child: TextButton(
                      onPressed: (){
                        setState(() {
                          isLoading = true;
                        });
                        _validate();
                      },
                      child: isLoading
                      ? const CircularProgressIndicator(color: AppColors.textColor)
                          : const Text('Post',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 15,
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void _postMatch() async {
    if (selectedDate.toString().isEmpty || selectedTime.toString().isEmpty ||
        _homeTeamController.text.isEmpty || _awayTeamController.text.isEmpty) {
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
    } else {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      if (user == null) {
        // Handle user not signed in
        return;
      }

      try {

        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('matches').add({
          'date': selectedDate.toString(),
          'time': selectedTime.toString(),
          'home_team': _homeTeamController.text,
          'away_team': _awayTeamController.text,
          'userId': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });


        // Display success message
       if(context.mounted){
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
       }
      } catch (e) {
        print('Error uploading post: $e');
        // Display error message
        if(context.mounted){
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
    }

  }

  _validate(){
    print("Selected date = $selectedDate");
     if(selectedDate == null){
      setState(() {
        isLoading = false;
      });
      Flushbar(
        title:  "Date missing",
        message:  "Please provide fixture date",
        duration:  const Duration(seconds: 3),
        backgroundColor: const Color(0Xffc71f37).withOpacity(0.5),
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(Icons.warning,
          color: Colors.white,
        ),
      ).show(context);
    }else if(selectedTime == null){
       setState(() {
         isLoading = false;
       });
       Flushbar(
         title:  "Time missing",
         message:  "Please provide time for the fixture",
         duration:  const Duration(seconds: 3),
         backgroundColor: const Color(0Xffc71f37).withOpacity(0.5),
         flushbarPosition: FlushbarPosition.TOP,
         icon: const Icon(Icons.warning,
           color: Colors.white,
         ),
       ).show(context);
     }else if(_homeTeamController.text.trim() == ""){
       setState(() {
         isLoading = false;
       });
       Flushbar(
         title:  "Home team missing",
         message:  "Please the home team name",
         duration:  const Duration(seconds: 3),
         backgroundColor: const Color(0Xffc71f37).withOpacity(0.5),
         flushbarPosition: FlushbarPosition.TOP,
         icon: const Icon(Icons.warning,
           color: Colors.white,
         ),
       ).show(context);
     }else if(_awayTeamController.text.trim() == ""){
       setState(() {
         isLoading = false;
       });
       Flushbar(
         title:  "Away team missing",
         message:  "Please provide away tem for the fixture",
         duration:  const Duration(seconds: 3),
         backgroundColor: const Color(0Xffc71f37).withOpacity(0.5),
         flushbarPosition: FlushbarPosition.TOP,
         icon: const Icon(Icons.warning,
           color: Colors.white,
         ),
       ).show(context);
     }else{
     _postMatch();
    }
  }
}
