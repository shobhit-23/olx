import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:olx/services/firebase_services.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

class ProductList extends StatelessWidget {
  FirebaseService _service = FirebaseService();
  final _format = NumberFormat('##,##,##0');
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: FutureBuilder<QuerySnapshot>(
            future: _service.products.get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                    backgroundColor: Colors.greenAccent,
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 340,
                  childAspectRatio: 2 / 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: snapshot.data!.size,
                itemBuilder: (BuildContext context, int i) {
                  var data = snapshot.data!.docs[i];
                  var _price = int.parse(data['price']);
                  String _formattedprice = '\$ ${_format.format(_price)}';
                  // print(snapshot.data!.size);
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: 120,
                                  child: Center(
                                    child: Image.network(data['images'][0]),
                                  )),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                _formattedprice,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data['brand'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                // style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Positioned(
                            right: 0.0,
                            child: LikeButton(
                              circleColor: CircleColor(
                                  start: Color(0xff00ddff),
                                  end: Color(0xff0099cc)),
                              bubblesColor: BubblesColor(
                                dotPrimaryColor: Color(0xff33b5e5),
                                dotSecondaryColor: Color(0xff0099cc),
                              ),
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  Icons.favorite,
                                  color: isLiked ? Colors.red : Colors.grey,
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              );
            }));
  }
}
