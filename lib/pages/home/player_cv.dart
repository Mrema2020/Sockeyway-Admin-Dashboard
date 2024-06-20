import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class PlayerCvPage extends StatefulWidget {
  const PlayerCvPage({super.key});

  @override
  State<PlayerCvPage> createState() => _PlayerCvPageState();
}

class _PlayerCvPageState extends State<PlayerCvPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    var appHeight = MediaQuery.of(context).size.height;
    var appWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: appHeight * 0.01),
            Center(
              child: Text(
                'Player Applications',
                style: TextStyle(
                  color: AppColors.primaryColor.withOpacity(0.7),
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(height: appHeight * 0.03),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('players').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No player available'));
                    }
                    return ListView(
                      children: snapshot.data!.docs.map((doc) {
                        return Column(
                          children: [
                            Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.6,
                                decoration: BoxDecoration(
                                    color: AppColors.secondaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.primaryColor.withOpacity(0.5))),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: appWidth * 0.15,
                                      height: appHeight * 0.3,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        child: Image.network(
                                          doc['picture'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: appWidth * 0.03, left: appWidth * 0.03),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: appHeight * 0.02),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Full Name',
                                                  style: TextStyle(
                                                    color: AppColors.primaryColor.withOpacity(0.5),
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Text(
                                                  'Email',
                                                  style: TextStyle(
                                                    color: AppColors.primaryColor.withOpacity(0.5),
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  doc['fullName'],
                                                  style: TextStyle(
                                                    color: AppColors.primaryColor.withOpacity(0.5),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  doc['email'],
                                                  style: TextStyle(
                                                    color: AppColors.primaryColor.withOpacity(0.5),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(),
                                            SizedBox(height: appHeight * 0.02),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Age',
                                                  style: TextStyle(
                                                    color: AppColors.primaryColor.withOpacity(0.5),
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Text(
                                                  'Nationality',
                                                  style: TextStyle(
                                                    color: AppColors.primaryColor.withOpacity(0.5),
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  doc['age'],
                                                  style: TextStyle(
                                                    color: AppColors.primaryColor.withOpacity(0.5),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  doc['nationality'],
                                                  style: TextStyle(
                                                    color: AppColors.primaryColor.withOpacity(0.5),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(),
                                            SizedBox(height: appHeight * 0.02),
                                            Text(
                                              'Position',
                                              style: TextStyle(
                                                color: AppColors.primaryColor.withOpacity(0.5),
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              doc['position'],
                                              style: TextStyle(
                                                color: AppColors.primaryColor.withOpacity(0.5),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: appHeight * 0.02),
                          ],
                        );
                      }).toList(),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
