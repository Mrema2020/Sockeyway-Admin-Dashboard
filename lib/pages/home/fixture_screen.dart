import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sockeyway_web/pages/home/post/add_match.dart';

import '../../utils/colors.dart';
import '../../utils/size_config.dart';

class FixturesScreen extends StatefulWidget {
  const FixturesScreen({super.key});

  @override
  State<FixturesScreen> createState() => _FixturesScreenState();
}

class _FixturesScreenState extends State<FixturesScreen> {
  @override
  Widget build(BuildContext context) {
    var appHeight =  MediaQuery.of(context).size.height;
    var appWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixtures'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('matches').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: Text(
                 "No fixture",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: SizeConfig.textMultiplier * 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),);
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Container(
                    height: 120,
                    width: 700,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor,),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 7,
                            child: SizedBox(
                              width: 680,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    doc['date'].toString().substring(0,10),
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    doc['time'].toString().substring(10,15),
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: SizeConfig.heightMultiplier * 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    doc['home_team'],
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Vs',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    doc['away_team'],
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
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
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMatch()),
          );
        },
        child: const Icon(
            Icons.add,
            color: AppColors.textColor,
        ),
      ),
    );
  }
}
