import 'dart:math';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'menu_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {

  final _firestore = FirebaseFirestore.instance;
  late LocationData loc;

  @override
  void initState() {
    func();

  }

  @override
  Widget build(BuildContext context) {
    func();
    return Scaffold(
      backgroundColor: 'eff7f6'.toColor(),
        appBar: AppBar(
          title: const Text("Master Chief",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'myOrders');
                  },
                  child: const Icon(Icons.fastfood)),
            )
          ],
        ),
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('resturants').snapshots(),
              builder: (context, snapshot)  {
                if (snapshot.hasData) {
                  final orders = snapshot.data!.docs;
                  List<Widget> below3Widgets = [];
                  List<Widget> above3Widgets = [];
                  for (var order in orders) {
                    String lat = order.get('latitude').toString();
                     String long = order.get('longitude').toString();
                    if(calculateDistance(loc.latitude!, loc.longitude!, double.parse(lat),double.parse(long))<3.0){
                      below3Widgets.add(Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                        child: GestureDetector(
                          onLongPress: (){
                            Clipboard.setData(ClipboardData(text:lat+","+long ));
                            const snackBar = SnackBar(content: Text('Latitude, Longitude copied'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MenuItems(order.get('email'))));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(order.get('name'),style: const TextStyle(fontSize: 20),),
                                      Row(
                                        children: const [
                                          Icon(Icons.copy),
                                          Text(">",style: TextStyle(fontSize: 20) ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ));
                    }else {
                      above3Widgets.add(Padding(
                        padding: const EdgeInsets.fromLTRB(
                            15.0, 5.0, 15.0, 5.0),
                        child: GestureDetector(
                          onLongPress: (){
                            Clipboard.setData(ClipboardData(text:lat+","+long ));
                            const snackBar = SnackBar(content: Text('Latitude, Longitude copied'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MenuItems(order.get('email'))));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(order.get('name'),
                                        style: TextStyle(fontSize: 20),),
                                      Row(
                                        children: const [
                                          Icon(Icons.copy),
                                          Text(">",style: TextStyle(fontSize: 20) ),
                                        ],
                                      )
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
                  return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: Colors.lightBlueAccent[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Within 3 miles",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                                  ),
                                  Column(children: below3Widgets),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: Colors.lightBlueAccent[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Other Restaurants",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                                  ),
                                  Column(children: above3Widgets),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("     *Long Press on the card to copy the location"),
                          )
                        ],

                      ));
                }
                return Container();
              }),
        ));
  }

  double calculateDistance(double lat1,double lon1,double lat2,double lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> func() async {
    var location=Location();
    var locationdata= await location.getLocation();
    loc=locationdata;
  }

}

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }

}

