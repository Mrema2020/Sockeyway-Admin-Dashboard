import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sockeyway_web/pages/home/post_screen.dart';

import '../../utils/colors.dart';
import '../../utils/size_config.dart';
import '../../widgets/toast.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  FirebaseAuth _auth1 = FirebaseAuth.instance;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _message = '';
  bool isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
      ),
      child: Scaffold(
        body: SafeArea(
            child: SizedBox(
              height: SizeConfig.heightMultiplier * 100,
              width: SizeConfig.widthMultiplier * 100,
              child: Stack(
                children: [
                  Container(
                    height: SizeConfig.heightMultiplier * 30,
                    width: SizeConfig.widthMultiplier * 100,
                    color: AppColors.primaryColor,
                    child: Center(
                      child: Text(
                        'Get Started, Sockeyway',
                        style: TextStyle(
                            fontSize: SizeConfig.textMultiplier * 3.5,
                            color: AppColors.textColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                      top: SizeConfig.heightMultiplier * 25,
                      child: Container(
                        height: SizeConfig.heightMultiplier * 70,
                        width: SizeConfig.widthMultiplier * 100,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            )),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier * 5,
                              right: SizeConfig.widthMultiplier * 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: SizeConfig.heightMultiplier * 3),
                              Center(
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      fontSize: SizeConfig.textMultiplier * 4,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor),
                                ),
                              ),
                              SizedBox(height: SizeConfig.heightMultiplier * 3),
                              Text(
                                'Name',
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 2,
                                    color: AppColors.primaryColor),
                              ),
                              SizedBox(
                                  height: SizeConfig.heightMultiplier * 5,
                                  child: TextField(
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          fontSize: SizeConfig.textMultiplier * 2,
                                          color: AppColors.primaryColor
                                              .withOpacity(0.6)),
                                      hintText: 'Username',
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.primaryColor
                                                .withOpacity(0.4)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: const Color(0xFF0B7689)
                                                .withOpacity(0.2)),
                                      ),
                                    ),
                                  )),
                              SizedBox(height: SizeConfig.heightMultiplier * 3),
                              Text(
                                'Email',
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 2,
                                    color: AppColors.primaryColor),
                              ),
                              SizedBox(
                                  height: SizeConfig.heightMultiplier * 5,
                                  child: TextField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          fontSize: SizeConfig.textMultiplier * 2,
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
                                    fontSize: SizeConfig.textMultiplier * 2,
                                    color: AppColors.primaryColor),
                              ),
                              SizedBox(
                                  height: SizeConfig.heightMultiplier * 5,
                                  child: TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                            fontSize:
                                            SizeConfig.textMultiplier * 2,
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
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.remove_red_eye_rounded,
                                            size: 20,
                                            color: AppColors.primaryColor,
                                          ),
                                        )),
                                  )),
                              SizedBox(height: SizeConfig.heightMultiplier * 5),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                   _signUpWithEmail();
                                  },
                                  child: Container(
                                    height: SizeConfig.heightMultiplier * 6,
                                    width: SizeConfig.widthMultiplier * 50,
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Center(
                                      child: isLoading
                                      ? const Center(child: CircularProgressIndicator(color: Colors.white))
                                      : Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            fontSize:
                                            SizeConfig.textMultiplier * 2,
                                            color: AppColors.textColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: SizeConfig.heightMultiplier * 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an Account?',
                                    style: TextStyle(
                                        fontSize: SizeConfig.textMultiplier * 2,
                                        color: AppColors.primaryColor),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize:
                                          SizeConfig.textMultiplier * 2,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            )),
      ),
    );
  }


  void _signUpWithEmail() async {
    try {
      UserCredential userCredential = await _auth1.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Save username in user's profile
      await userCredential.user?.updateProfile(displayName: _usernameController.text.trim());
      setState(() {
        _message = 'User ${_usernameController.text.trim()} registered';
        isLoading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (_) => PostScreen()));
      showToast(message: "Registration Successfully");
    } catch (e) {
      setState(() {
        _message = e.toString();
        isLoading = false;
      });
      showToast(message: '$e');
    }
  }
}
