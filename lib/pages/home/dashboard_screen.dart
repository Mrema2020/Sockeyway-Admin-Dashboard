import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 18.0),
              child: Icon(CupertinoIcons.person_alt_circle),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                "Welcome,",
                style: TextStyle(fontSize: 20.0, color: Colors.blueGrey.shade600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                "${user!.displayName}",
                style: TextStyle(fontSize: 20.0, color: Colors.blueGrey.shade600),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text('Sockeyway Admin Dashboard', style: TextStyle(fontSize: 20.0, color: Colors.blueGrey.shade600)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Center(
              child: Text(
                'Summary',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryColor),
                  );
                }
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SummaryCard(
                    title: 'Total Posts',
                    count: '${snapshot.data!.docs.length}',
                    icon: Icons.flag_circle,
                    color: Colors.green,
                  ),
                );
                ;
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('news').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryColor),
                  );
                }
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SummaryCard(
                    title: 'Available Total News',
                    count: '${snapshot.data!.docs.length}',
                    icon: Icons.article,
                    color: Colors.blue,
                  ),
                );
                ;
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('matches').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryColor),
                  );
                }
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SummaryCard(
                    title: 'Remaining Fixtures',
                    count: '${snapshot.data!.docs.length}',
                    icon: Icons.sports_soccer,
                    color: Colors.red,
                  ),
                );
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('players').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryColor),
                  );
                }
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SummaryCard(
                    title: 'Total Player Cv',
                    count: '${snapshot.data!.docs.length}',
                    icon: Icons.person_pin,
                    color: Colors.blueGrey,
                  ),
                );
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('tickets').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryColor),
                  );
                }
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SummaryCard(
                    title: 'Tickets Issued',
                    count: '${snapshot.data!.docs.length}',
                    icon: CupertinoIcons.tickets_fill,
                    color: Colors.brown,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  const SummaryCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    size: 40.0,
                    color: color,
                  ),
                  Text(
                    count,
                    style: const TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
