import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/size_config.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SizedBox(
            height: SizeConfig.heightMultiplier * 100,
            width: SizeConfig.widthMultiplier * 60,
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tickets',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: SizeConfig.textMultiplier * 1,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('tickets').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No tickets available'));
                      }
                      return ListView(
                        children: snapshot.data!.docs.map((doc) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: Colors.deepOrangeAccent[100],
                                      width: SizeConfig.widthMultiplier * 20,
                                      height: SizeConfig.heightMultiplier * 11,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            CupertinoIcons.tickets,
                                            color: Colors.white,
                                            size: 60,
                                          ),
                                          Text(
                                            doc['status'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: SizeConfig.textMultiplier * 0.7,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Name',
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: SizeConfig.textMultiplier * 0.9,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            doc['Name'],
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: SizeConfig.textMultiplier * 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Match',
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: SizeConfig.textMultiplier * 0.9,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            doc['match'],
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: SizeConfig.textMultiplier * 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Seat',
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: SizeConfig.textMultiplier * 0.9,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            doc['seat'],
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: SizeConfig.textMultiplier * 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Amount',
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: SizeConfig.textMultiplier * 0.9,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            doc['amount'],
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: SizeConfig.textMultiplier * 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
