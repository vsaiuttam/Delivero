import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_xi/variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuItems extends StatefulWidget {
  String rest;

  MenuItems(this.rest, {Key? key}) : super(key: key);

  @override
  _MenuItemsState createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  var q = 0;
  var q2;
  double test = 0.0;
  var e =TextEditingController();
  var present= false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.cyan[100],
        appBar: appbar('Menu'),
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('restitems').snapshots(),
              builder: (context, ritems1) {
                if (ritems1.hasData) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('items').snapshots(),
                    builder: (context, allitems1) {
                      if (allitems1.hasData) {
                        return  StreamBuilder<QuerySnapshot>(
                            stream: _firestore.collection('cart').snapshots(),
                            builder: (context, allcarts1) {
                              if (allcarts1.hasData) {
                                final ritems = ritems1.data!.docs;
                                final allitems = allitems1.data!.docs;
                                final allcarts = allcarts1.data!.docs;
                                var i = 0;
                                String id = '';
                                List<Widget> orderWidgets = [];
                                for (var ritem in ritems) {
                                  if (widget.rest == ritem.get('email')) {
                                    for (var item in allitems) {
                                      if (ritem.get('itemid') ==
                                          item.get('id')) {
                                        for (var cart in allcarts) {
                                          if (widget.rest ==
                                              cart.get('resturantid') &&
                                              _auth.currentUser!.email ==
                                                  cart.get('custid') &&
                                              ritem.get('itemid') ==
                                                  cart.get('itemid')) {
                                            e.text=cart.get('count').toString();
                                          }
                                        }

                                        orderWidgets.add(Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15.0, 5.0, 15.0, 5.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog<String>(context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text('Enter quantity'),
                                                    content: SizedBox(
                                                      height: 110.0,
                                                      child: Column(
                                                        children: [
                                                          TextField(
                                                              controller: e,
                                                            keyboardType: TextInputType.number,
                                                          ),
                                                          const SizedBox(height:10.0 ,),
                                                          ElevatedButton(onPressed: (){
                                                            present=false;
                                                            for (var cart in allcarts) {
                                                              if (widget.rest ==
                                                                  cart.get('resturantid') &&
                                                                  _auth.currentUser!.email ==
                                                                      cart.get('custid') &&
                                                                  ritem.get('itemid') ==
                                                                      cart.get('itemid')) {
                                                                present = true;
                                                                id = cart.id;
                                                              }
                                                            }
                                                            if(present){
                                                              _firestore.collection('cart').doc(id).update(
                                                                  {"count":int.parse(e.text)});
                                                            }else{
                                                              _firestore.collection('cart').add({
                                                                "count":int.parse(e.text),
                                                                "custid":_auth.currentUser!.email,
                                                                "itemid": item.get("id"),
                                                                "resturantid":ritem.get('email'),
                                                                "done":2
                                                              });
                                                            }
                                                            e.clear();
                                                            Navigator.pop(context);
                                                          },
                                                              child: const Text('save')
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  )
                                              );
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 210.85,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                                item.get(
                                                                    'image')))),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(item.get('name'),
                                                          style: GoogleFonts.tinos(
                                                            fontSize: 20
                                                          )
                                                        ),
                                                        Text("Rs-" +
                                                            ritem.get('price'))
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ));
                                      }
                                    }
                                  }
                                }
                                return SingleChildScrollView(
                                    child: Column(children: orderWidgets));
                              }
                              return Container();
                            });
                      }
                      return Container();
                    },
                  );
                }
                return Container();
              }),
        ));
  }
}
