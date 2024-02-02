import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_xi/Restaurant/rest_login2.dart';
import 'package:project_xi/customer/cust_login.dart';
import 'package:project_xi/Restaurant/add_items.dart';
import 'package:project_xi/customer/cust_reg.dart';
import 'package:project_xi/customer/menu_page.dart';
import 'package:project_xi/customer/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_xi/Restaurant/rest_home.dart';
import 'package:project_xi/Restaurant/rest_items.dart';
import 'package:project_xi/Restaurant/rest_reg.dart';
import 'customer/my_orders.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => LoginPage(),
        'home' :(context) =>  Home(),
        'register' : (context) => CustReg(),
        'login' : (context) => LoginPage(),
        'restreg' : (context) => ResturantRegistration(),
        'itemslist':(context) => RestItems(),
        'resthome': (context)=>RestHome(),
        'restlogin' : (context) => LoginRest(),
        'additems' : (context) => Additems(),
        'myOrders' : (context)=>MyOders()
      },
    );
  }
}
