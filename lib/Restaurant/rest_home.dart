import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RestHome extends StatefulWidget {
  const RestHome({Key? key}) : super(key: key);

  @override
  _RestHomeState createState() => _RestHomeState();
}

class _RestHomeState extends State<RestHome> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  var _restName = "";
  var p = "";
  var id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, 'additems');
            }),
        appBar: AppBar(
          title: const Text("Restraunt Orders"),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'itemslist');
                  },
                  child: const Icon(Icons.fastfood)),
            )
          ],
        ),
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('cart').snapshots(),
              builder: (context, allcarts) {
                print(1);
                if (allcarts.hasData) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('items').snapshots(),
                      builder: (context, allitems) {
                        print(2);
                        if (allitems.hasData) {
                          return StreamBuilder<QuerySnapshot>(
                              stream: _firestore
                                  .collection('restitems')
                                  .snapshots(),
                              builder: (context, allrestitems) {
                                print(3);
                                if (allrestitems.hasData) {
                                  return StreamBuilder<QuerySnapshot>(
                                      stream: _firestore
                                          .collection('resturants')
                                          .snapshots(),
                                      builder: (context, resturants) {
                                        print(4);
                                        if (resturants.hasData) {
                                          final carts = allcarts.data!.docs;
                                          final items = allitems.data!.docs;
                                          final restitems =
                                              allrestitems.data!.docs;
                                          final rests = resturants.data!.docs;
                                          List<Widget> orderWidgets = [];
                                          for (var cart in carts) {
                                            if (cart.get('resturantid') ==
                                                _auth.currentUser!.email) {
                                              for (var restitem in restitems) {
                                                if (cart.get('itemid') ==
                                                    restitem.get('itemid')) {
                                                  p = (int.parse(restitem
                                                              .get('price')) *
                                                          cart.get('count'))
                                                      .toString();
                                                }
                                              }

                                              for (var item in items) {
                                                if (item.get('id') ==
                                                    cart.get('itemid')) {
                                                  id = cart.id;
                                                  orderWidgets.add(Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        15.0, 5.0, 15.0, 5.0),
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: 210.85,
                                                            decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    image: NetworkImage(
                                                                        item.get(
                                                                            'image')))),
                                                          ),
                                                          Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          16.0,
                                                                          10.0,
                                                                          0.0,
                                                                          10.0),
                                                                  child: Text('From : ' +
                                                                      cart.get('custid')+
                                                                      '\n\nItem : ' +
                                                                      item.get(
                                                                          'name')),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          15.0),
                                                                  child: Text('Quatity : ' +
                                                                      cart
                                                                          .get(
                                                                              'count')
                                                                          .toString()),
                                                                )
                                                              ]),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    16.0,
                                                                    0.0,
                                                                    16.0,
                                                                    16.0),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                    child:
                                                                        ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                          primary:
                                                                              Colors.green),
                                                                  child: Text(
                                                                      "Rs-" +
                                                                          p),
                                                                  onPressed:
                                                                      () {},
                                                                )),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                          primary:
                                                                              Colors.red),
                                                                  child: const Text(
                                                                      "Cancel Order"),
                                                                  onPressed:
                                                                      () {
                                                                    _firestore
                                                                        .collection(
                                                                            "cart")
                                                                        .doc(id)
                                                                        .delete();
                                                                  },
                                                                )),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ));
                                                }
                                              }
                                            }
                                          }
                                          return SingleChildScrollView(
                                              child: Column(
                                                  children: orderWidgets));
                                        }
                                        return Container();
                                      });
                                }
                                return Container();
                              });
                        }
                        return Container();
                      });
                }
                return Container();
              }),
        ));
  }
}
