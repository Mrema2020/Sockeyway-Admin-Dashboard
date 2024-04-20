import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/size_config.dart';
import 'post/add_post.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var appHeight = MediaQuery.of(context).size.height;
    var appWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: SizedBox(
                    width: 600,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: appWidth * 0.03,
                              height: appHeight * 0.03,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image:
                                          AssetImage("assets/sockeyway.png"))),
                            ),
                            const Text(
                              'Sockeyway Fc',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.primaryColor,
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: appHeight * 0.6,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.primaryColor
                                        .withOpacity(0.4)),
                                image: DecorationImage(
                                    image: NetworkImage(doc['imageUrl']),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Sockeyway ',
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: doc['description'],
                                  style: const TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection("posts")
                                .doc(doc.id)
                                .collection('comments')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(child: Container());
                              }

                              if (snapshot.hasError) {
                                return Center(child: Container());
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 5),
                                  child: Text(
                                    '${snapshot.data!.docs.length} comments',
                                    style: TextStyle(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.4),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${snapshot.data!.docs.length} Comments",
                                      style: TextStyle(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.5),
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: TextButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (_) => _commentSection(doc.id, doc['imageUrl'])
                                            );
                                          },
                                          child: const Text(
                                            "View Comments",
                                            style: TextStyle(
                                                color: AppColors.textColor,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        const Divider(
                          indent: 5,
                          endIndent: 5,
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
            MaterialPageRoute(builder: (context) => AddPostScreen()),
          );
        },
        child: const Icon(
          Icons.add,
          color: AppColors.textColor,
        ),
      ),
    );
  }

  _commentSection(postId, String imageUrl) {
    print("Image Url = $imageUrl");
    return SizedBox(
      width: SizeConfig.widthMultiplier * 100,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection("posts")
                    .doc(postId)
                    .collection('comments')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Text('No comment',
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 2,
                                color:
                                    AppColors.primaryColor.withOpacity(0.5),
                                fontWeight: FontWeight.bold)));
                  }
                  return Center(
                    child: Container(
                      height: 400,
                      width: 600,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                             "Comments",
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 200,
                                    height: 400,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(imageUrl),
                                          fit: BoxFit.cover
                                        )
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView(
                                      children: snapshot.data!.docs.map((doc) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: Icon(
                                                  CupertinoIcons.person_alt_circle,
                                                  color: AppColors.primaryColor
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      doc['username'],
                                                      style: const TextStyle(
                                                          color: AppColors.primaryColor,
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    Text(
                                                      doc['text'],
                                                      style: const TextStyle(
                                                          color: AppColors.primaryColor,
                                                          fontSize: 13),
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList()),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
