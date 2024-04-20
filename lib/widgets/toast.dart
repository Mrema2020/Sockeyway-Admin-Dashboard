

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/colors.dart';

void showToast({required String message}){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.primaryColor,
      textColor: Colors.white,
      fontSize: 16.0
  );
}