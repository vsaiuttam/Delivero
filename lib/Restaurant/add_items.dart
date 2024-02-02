import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_xi/variables.dart';
import 'package:flutter/material.dart';
import 'package:project_xi/variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Additems extends StatefulWidget {
  const Additems({Key? key}) : super(key: key);

  @override
  _AdditemsState createState() => _AdditemsState();
}

class _AdditemsState extends State<Additems> {

  final _auth = FirebaseAuth.instance;
  var price = TextEditingController();

  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        title: Text('Select items'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pop(context);
        },
        child: Icon(Icons.task_alt),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('items').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final orders = snapshot.data!.docs;
              List<Widget> orderWidgets = [];
              for (var order in orders) {
                orderWidgets.add(Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                  child: GestureDetector(
                    onTap: (){
                      showBottomSheet(context: context,
                          builder: (context) => Container(
                            height: 100.0,
                            child: Column(
                              children: [
                                Text(order.get('name'),
                                style: GoogleFonts.dancingScript(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold
                          ),
                                ),
                                Row(
                                  children: [
                                    const SizedBox(width: 15.0,),
                                    Expanded(
                                      flex: 8,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: 'Enter price'
                                        ),
                                        controller: price,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                        child: ElevatedButton(
                                          onPressed: (){
                                            FirebaseFirestore.instance
                                                .collection('restitems')
                                                .add({
                                              'email': _auth.currentUser!.email,
                                              'itemid' : order.get('id'),
                                              'price' : price.text
                                            });
                                            Navigator.pop(context);
                                            price.clear();
                                          },
                                         child: const Text('save',style: TextStyle(fontSize: 17),),
                                        )
                                    )
                                  ],
                                ),
                              ],
                            )
                          )
                      );

                    },
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
                                    image: NetworkImage(order.get('image'))
                                )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(order.get('name'),
                                  style: GoogleFonts.dancingScript(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ));
              };
              return SingleChildScrollView(child: Column(children: orderWidgets));
            }
            return Container();
          }),
    );
  }
}
