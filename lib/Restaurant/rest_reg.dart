import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class ResturantRegistration extends StatefulWidget {
  const ResturantRegistration({Key? key}) : super(key: key);

  @override
  _ResturantRegistrationState createState() => _ResturantRegistrationState();
}

class _ResturantRegistrationState extends State<ResturantRegistration> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _longitude = TextEditingController();
  final _latitude = TextEditingController();
  final _auth = FirebaseAuth.instance;
  var spinning = false;


  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: spinning,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height:10.0 ,),
              Center(
                child: Text('Register your restaurant',
                  style: TextStyle(
                    fontSize: 30.0
                  ),
                ),
              ),
              SizedBox(height: 30.0,),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Text('Name :',
                      style: TextStyle(
                        fontSize: 20.0
                      ),
                    ),
                    Container(
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: TextField(
                              controller: _name,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    const Text('Email :',
                      style: TextStyle(
                          fontSize: 20.0
                      ),
                    ),
                    Container(
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _email,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    const Text('Password :',
                      style: TextStyle(
                          fontSize: 20.0
                      ),
                    ),
                    Container(
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: TextField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: _password,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15.0,),
              const Text('Enter the location of Restraunt',
                style: TextStyle(
                  fontSize: 20.0
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Text('Latitude :',
                      style: TextStyle(
                          fontSize: 20.0
                      ),
                    ),
                    Container(
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _latitude,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Text('Longitude :',
                      style: TextStyle(
                          fontSize: 20.0
                      ),
                    ),
                    Container(
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _longitude,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              ElevatedButton(
                  onPressed: (){
                    setState(() {
                      spinning=true;
                    });
                    onRegesteringIn(context);
                  },
                  child: Text('Submit')
              )
            ],
          ),
        ),
      ),
    );
  }

  void onRegesteringIn(BuildContext context) async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: _email.text, password: _password.text);
      FirebaseFirestore.instance
          .collection('resturants')
          .add({
        'name': _name.text,
        'email': _email.text,
        'longitude': double.parse(_longitude.text),
        'latitude': double.parse(_latitude.text)
      });

      if (newUser != null) {//TODO: do this
        Navigator.of(context)
            .pushNamedAndRemoveUntil('resthome', (Route<dynamic> route) => false);
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      spinning=false;
    });
  }
}
//
// Expanded(
// flex: 2,
// child: Padding(
// padding: const EdgeInsets.fromLTRB(16.0,0.0,16.0,0.0),
// child: TextField(
// decoration: InputDecoration(
// hintText: 'Latitude'
// ),
// controller: _latitude,
// ),
// ),
// ),
// Expanded(
// flex: 8,
// child: Padding(
// padding: const EdgeInsets.fromLTRB(16.0,0.0,16.0,0.0),
// child: TextField(
// decoration: InputDecoration(
// hintText: 'Longitude'
// ),
// controller: _longitude,
// ),
// ),),