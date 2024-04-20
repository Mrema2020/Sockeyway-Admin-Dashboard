
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({super.key});

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> slideAnimation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    slideAnimation = CurvedAnimation(
        parent: controller, curve: Curves.fastLinearToSlowEaseIn);

    controller.addListener(() {});
    controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PopScope(
        canPop: false,
        child: Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: slideAnimation,
            child: Container(
              height: 400,
              width: 700,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                children: [
                  Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.cancel_outlined,
                        color: AppColors.secondaryColor,
                        ),
                      )
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Logout',
                        style:  TextStyle(
                            color: AppColors.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Are you sure you want to logout?',
                        style:  TextStyle(
                          color: AppColors.textColor,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            width: 90,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.0),
                                border: Border.all(
                                  color: AppColors.secondaryColor,
                                )
                            ),
                            child: TextButton(
                              onPressed: () => {
                                Navigator.pop(context),
                              },
                              child: Text(
                                'Cancel'.toUpperCase(),
                                style:  TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color:
                            AppColors.secondaryColor,
                          ),
                          Container(
                            height: 50,
                            width: 90,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                _signOut(context);
                              },
                              child: Text(
                                'Yes'.toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
