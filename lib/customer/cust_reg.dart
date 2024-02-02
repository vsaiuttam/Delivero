import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Login/palatte.dart';
import '../Login/background_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class CustReg extends StatefulWidget {
  const CustReg({Key? key}) : super(key: key);

  @override
  _CustRegState createState() => _CustRegState();
}

class _CustRegState extends State<CustReg> {
  final username = TextEditingController();
  final password = TextEditingController();
  final _auth = FirebaseAuth.instance;
  var spinning = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spinning,
      child: Stack(
        children: [
          BackgroundImage(),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      child: const Center(
                        child: Text(
                          'Master Chief',
                          style: kHeading,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[600]!.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: TextField(
                                    controller: username,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 20),
                                      border: InputBorder.none,
                                      hintText: 'Email',
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: Icon(
                                          Icons.e_mobiledata,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                      hintStyle: kBodyText,
                                    ),
                                    style: kBodyText,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[600]!.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: TextField(
                                    controller: password,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 20),
                                      border: InputBorder.none,
                                      hintText: 'Password',
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: Icon(
                                          FontAwesomeIcons.font,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                      hintStyle: kBodyText,
                                    ),
                                    obscureText: true,
                                    style: kBodyText,
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 100,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      spinning=true;
                                    });
                                    onRegesteringIn(context);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16.0),
                                    child: Text(
                                      'Register',
                                      style: kBodyText,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 80,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void onRegesteringIn(BuildContext context) async {
    try {
      print("HI");
      final newUser = await _auth.createUserWithEmailAndPassword(email: username.text, password: password.text);
      print("q");
      if (newUser != null) {
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      spinning=false;
    });

  }

}

