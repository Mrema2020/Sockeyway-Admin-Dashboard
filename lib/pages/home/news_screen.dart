import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sockeyway_web/pages/home/post/add_news.dart';

import '../../utils/colors.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    var appHeight =  MediaQuery.of(context).size.height;
    var appWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest News'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('news').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ));
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Container(
                    color: AppColors.secondaryColor.withOpacity(0.1),
                    width: appWidth * 0.6,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: appHeight * 0.3,
                            width: appWidth * 0.25,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primaryColor.withOpacity(0.4)),
                                image: DecorationImage(
                                    image: NetworkImage(doc['imageUrl']),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    doc['title'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    doc['description'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.primaryColor,),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
              //   ListTile(
              //   leading: Image.network(doc['imageUrl']),
              //   title: Text(doc['description']),
              // );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNews()),
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
