import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_xi/variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RestItems extends StatefulWidget {
  const RestItems({Key? key}) : super(key: key);

  @override
  _RestItemsState createState() => _RestItemsState();
}

class _RestItemsState extends State<RestItems> {

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
        appBar: appbar('My Items'),
        body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('restitems').snapshots(),
    builder: (context, ritems1) {
      if (ritems1.hasData) {
        return StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('items').snapshots(),
          builder: (context, allitems1) {
            if (allitems1.hasData) {
              final ritems = ritems1.data!.docs;
              final allitems = allitems1.data!.docs;
              List<Widget> orderWidgets = [];
              for (var ritem in ritems) {
                if (_auth.currentUser!.email == ritem.get('email')) {
                  for (var item in allitems) {
                    if (ritem.get('itemid') == item.get('id')) {
                      orderWidgets.add(Padding(
                        padding: const EdgeInsets.fromLTRB(
                            15.0, 5.0, 15.0, 5.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 210.85,

                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(item.get('image'))
                                    )
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item.get('name'),style: GoogleFonts.tinos(
                                      fontSize: 20
                                    )),
                                    Text("Rs-"+ritem.get('price'))
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
              return SingleChildScrollView(child: Column(children: orderWidgets));
            }
            return Container();
          },
        );
      }
      return Container();
    }),
    );
    }
  }
