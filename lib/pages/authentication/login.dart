import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sockeyway_web/pages/home/home.dart';

import '../../utils/colors.dart';
import '../../utils/size_config.dart';
import '../../widgets/toast.dart';


 class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
   TextEditingController _emailController = TextEditingController();
   TextEditingController _passwordController = TextEditingController();
  String _message = '';
  bool isLoading = false;
  bool _obscureText = true;

  _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    // _emailController = TextEditingController(text: "solo@gmail.com");
    // _passwordController = TextEditingController(text: "123456");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appHeight =  MediaQuery.of(context).size.height;
    var appWidth = MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.primaryColor
      ),
      child: Scaffold(
        body: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: appHeight,
                      width: appWidth * 0.5,
                      child: const Center(
                        child: Text(
                          'Sockeyway Fc',
                          style: TextStyle(
                              fontSize: 45,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.widthMultiplier * 5,
                                right: SizeConfig.widthMultiplier * 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: SizeConfig.heightMultiplier * 5),
                                Center(
                                  child: Text(
                                    'Welcome',
                                    style: TextStyle(
                                        fontSize: SizeConfig.textMultiplier * 2,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor),
                                  ),
                                ),
                                SizedBox(height: SizeConfig.heightMultiplier * 4),
                                Text(
                                  'Email',
                                  style: TextStyle(
                                      fontSize: SizeConfig.textMultiplier * 0.8,
                                      color: AppColors.primaryColor),
                                ),
                                SizedBox(
                                    height: SizeConfig.heightMultiplier * 5,
                                    child: TextField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                            fontSize: SizeConfig.textMultiplier * 0.8,
                                            color: AppColors.primaryColor
                                                .withOpacity(0.6)),
                                        hintText: 'Enter your email',
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.4)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.2)),
                                        ),
                                      ),
                                    )),
                                SizedBox(height: SizeConfig.heightMultiplier * 3),
                                Text(
                                  'Password',
                                  style: TextStyle(
                                      fontSize: SizeConfig.textMultiplier * 0.8,
                                      color: AppColors.primaryColor),
                                ),
                                SizedBox(
                                    height: SizeConfig.heightMultiplier * 5,
                                    child: TextField(
                                      controller: _passwordController,
                                      obscureText: _obscureText,
                                      decoration: InputDecoration(
                                          hintStyle: TextStyle(
                                              fontSize:
                                              SizeConfig.textMultiplier * 0.8,
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.6)),
                                          hintText: 'Enter your password',
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.primaryColor
                                                    .withOpacity(0.4)),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.primaryColor
                                                    .withOpacity(0.2)),
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              _toggle();
                                            },
                                            icon: _obscureText
                                                ? const Icon(
                                              CupertinoIcons.eye_slash_fill,
                                              size: 20,
                                              color: AppColors.primaryColor,
                                            )
                                                : const Icon(
                                              CupertinoIcons.eye,
                                              size: 20,
                                              color: AppColors.primaryColor,
                                            )
                                          )),
                                    )),

                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      _validate();
                                    },
                                    child: Container(
                                      height: SizeConfig.heightMultiplier * 3,
                                      width: SizeConfig.widthMultiplier * 30,
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Center(
                                        child: isLoading
                                        ? const Center(child: CircularProgressIndicator(color: Colors.white,))
                                        : Text(
                                          'Login',
                                          style: TextStyle(
                                              fontSize:
                                              SizeConfig.textMultiplier * 0.8,
                                              color: AppColors.textColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: SizeConfig.heightMultiplier * 3),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void _signInWithEmail() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      setState(() {
        _message = 'Welcome, ${userCredential.user?.displayName ?? 'Unknown user'}!';
        isLoading = false;
      });
      _emailController.clear();
      _passwordController.clear();
      Navigator.push(context, MaterialPageRoute(builder: (_) =>  const HomeScreen()));
      showToast(message: 'Login Successfully');

    } catch (e) {
      print("Message = $e");
      setState(() {
        _message = e.toString();
        isLoading = false;
      });
      if (_message ==
          "[firebase_auth/invalid-email] The email address is badly formatted." ||
          _message ==
              "[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired." &&
              context.mounted) {
        Flushbar(
          title: "Error",
          message: "Invalid email / password",
          duration: const Duration(seconds: 3),
          backgroundColor: const Color(0Xffc71f37),
          flushbarPosition: FlushbarPosition.TOP,
          margin: const EdgeInsets.all(15),
          icon: const Icon(
            Icons.warning,
            color: Colors.white,
          ),
        ).show(context);
        setState(() {
          _passwordController.clear();
        });
      } else if (_message ==
          "[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred." &&
          context.mounted) {
        Flushbar(
          title: "Network Error",
          message: "Please connect to the internet",
          duration: const Duration(seconds: 3),
          backgroundColor: const Color(0Xffc71f37),
          flushbarPosition: FlushbarPosition.TOP,
          margin: const EdgeInsets.all(15),
          icon: const Icon(
            Icons.warning,
            color: Colors.white,
          ),
        ).show(context);
      } else if (context.mounted) {
        Flushbar(
          title: "Error",
          message: "$e",
          duration: const Duration(seconds: 3),
          backgroundColor: const Color(0Xffc71f37),
          flushbarPosition: FlushbarPosition.TOP,
          margin: const EdgeInsets.all(15),
          icon: const Icon(
            Icons.warning,
            color: Colors.white,
          ),
        ).show(context);
      }
    }
  }

  _validate(){
    if(_emailController.text.trim() == ""){
      setState(() {
        isLoading = false;
      });
      Flushbar(
        title:  "Email missing",
        message:  "Please provide your email",
        duration:  const Duration(seconds: 3),
        backgroundColor: const Color(0Xffc71f37).withOpacity(0.5),
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(Icons.warning,
          color: Colors.white,
        ),
      ).show(context);
    }else if(_passwordController.text.trim() == ""){
      setState(() {
        isLoading = false;
      });
      Flushbar(
        title:  "Password missing",
        message:  "Please provide your login password",
        duration:  const Duration(seconds: 3),
        backgroundColor: const Color(0Xffc71f37).withOpacity(0.5),
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(Icons.warning,
          color: Colors.white,
        ),
      ).show(context);
    }else{
      _signInWithEmail();
    }
  }
}