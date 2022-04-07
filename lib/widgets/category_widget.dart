import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/form/cat_provider.dart';
import 'package:provider/provider.dart';
import 'package:olx/services/firebase_services.dart';

class category_widgit extends StatelessWidget {
  const category_widgit({Key? key}) : super(key: key);

  Future<List<QueryDocumentSnapshot<Object?>>> getCategories() async {
    QuerySnapshot qn =
        await FirebaseFirestore.instance.collection("categories").get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseService _services =
        FirebaseService(); // 'package:olx/services/firebase_services.dart'

    var _catProvider = Provider.of<CategoryProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          child: FutureBuilder<dynamic>(
        future: getCategories(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return Container(
              child: Text("Loading"),
            );
          } else {
            return Container(
              height: 180,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Categories',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      TextButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Text('See all',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                              ),
                            ],
                          )),
                    ],
                  ),
                  Expanded(
                      child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // print(snapshot.data.runtimeType),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data[index];
                      print(snapshot.data[index]['image']);
                      _catProvider.getCategory(doc['catName']);
                      _catProvider.getSnapshot(doc);
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 75,
                            height: 20,
                            child: Column(
                              children: [
                                Image.network(doc['image']),
                                Text(
                                  doc['catName'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            // decoration: BoxDecoration(
                            //   border: Border.all(
                            //       color: Theme.of(context)
                            //           .primaryColor
                            //           .withRed(80)),
                            // )
                          ));
                    },
                  ))
                ],
              ),
            );
          }
        },
      )),
    );
  }
}
