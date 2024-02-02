import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class MyOders extends StatefulWidget {
  const MyOders({Key? key}) : super(key: key);

  @override
  _MyOdersState createState() => _MyOdersState();
}

class _MyOdersState extends State<MyOders> {

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
 var _restName = "";
 var p='';
  
  @override
  Widget build(BuildContext context) {
    num total =0;
    return Scaffold(
        backgroundColor: Colors.cyan[100],
      appBar: AppBar(title: Text("MY ORDERS"),),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('cart').snapshots(),
          builder: (context,allcarts) {
            if(allcarts.hasData){
              return StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('items').snapshots(),
                  builder: (context,allitems){
                  if(allitems.hasData){
                    return StreamBuilder<QuerySnapshot>(
                        stream: _firestore.collection('restitems').snapshots(),
                        builder:(context,allrestitems){
                          if(allrestitems.hasData){
                            return StreamBuilder<QuerySnapshot>(
                                stream: _firestore.collection('resturants').snapshots(),
                                builder: (context,resturants){
                                  if(resturants.hasData){
                                    final carts = allcarts.data!.docs;
                                    final items = allitems.data!.docs;
                                    final restitems = allrestitems.data!.docs;
                                    final rests = resturants.data!.docs;
                                    List<Widget> orderWidgets = [];
                                    for(var cart in carts){
                                      if(cart.get('custid')==_auth.currentUser!.email){
                                        for(var restitem in restitems){
                                          if(cart.get('resturantid')==restitem.get('email') && cart.get('itemid')==restitem.get('itemid')){
                                            p=(int.parse(restitem.get('price'))*cart.get('count')).toString();
                                            total+=int.parse(restitem.get('price'))*cart.get('count');
                                          }
                                        }
                                        for(var rest in rests){
                                          if(cart.get('resturantid')==rest.get('email')){
                                            _restName=rest.get('name');
                                          }
                                        }
                                        for(var item in items){
                                            if(item.get('id')==cart.get('itemid')){
                                              orderWidgets.add(Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    15.0, 5.0, 15.0, 5.0),
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
                                                            8.0),
                                                        child: Column(
                                                          children: [
                                                            Text(_restName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20
                                                            ),),
                                                            SizedBox(height: 10,),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text("  "+item.get('name')+" x"+cart.get('count').toString(),style: GoogleFonts.tinos(
                                                                  fontSize: 20
                                                                )),
                                                                Text("R"+
                                                                    "s-" +
                                                                    p+"  ")
                                                              ],
                                                            ),
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
                                    return Column(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context).size.height*0.8+2,
                                          child: SingleChildScrollView(
                                              child: Column(children: orderWidgets)),
                                        ),
                                        Container(
                                          color: Colors.cyan,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                            child: Container(
                                              height: MediaQuery.of(context).size.height*0.075,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Total Amount: $total",style: const TextStyle(fontSize: 17),),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(primary: Colors.orange),
                                                      onPressed: (){},
                                                      child: const Text("Checkout"))
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }
                                  return Container();
                                });
                          }
                            return Container();
                        });
                  }
                    return Container();
                  }
              );
            }
            return Container();
          }
        )
      )
    );
  }
}
