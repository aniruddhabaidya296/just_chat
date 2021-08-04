import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_chat/components/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

import 'homepage.dart';

class EmailLogIn extends StatefulWidget {
  const EmailLogIn({Key key}) : super(key: key);

  @override
  _EmailLogInState createState() => _EmailLogInState();
}

class _EmailLogInState extends State<EmailLogIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var _success;
  String _userEmail;
  void _showDialog(String textField) {
    // flutter defined function
    print("_showDialog called");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.blue[100],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text("Error"),
          content: new Text("$textField"),
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                elevation: 5,
                color: Colors.blue,
                onPressed: () async {
                  {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Close',
                  style: TextStyle(
                    fontFamily: 'VisbyRoundCF',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _signInWithEmailAndPassword() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    // final formState = _formkey.currentState;
    // if (formState.validate()) {
    //   formState.save();
    try {
      var user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      print(
          "##########################user is: $user################################");
      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email;
          currentUserId = user.uid;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              ModalRoute.withName('/home'));
        });
      } else {
        setState(() {
          _success = false;
        });
      }
    } catch (e) {
      String errorMessage = e.toString();
      var parts = errorMessage.split("]");
      var finalMessage = parts[1].trimLeft();
      _showDialog("$finalMessage");
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }, child: Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: Text("Email Sign In"),
        ),
        key: _formKey,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue[100]),
            width: MediaQuery.of(context).size.width / 1.3,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/tutorhub_logo.PNG'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 12,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 30, right: 30, bottom: 10, top: 10),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              borderSide: BorderSide(color: Colors.black12)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: 'Email'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Valid Email';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 12,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 30, right: 30, top: 10, bottom: 10),
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              borderSide: BorderSide(color: Colors.black12)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide:
                                  const BorderSide(color: Colors.black)),
                          labelText: 'Password'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Valid Password';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    elevation: 10,
                    color: Colors.blue,
                    onPressed: () async {
                      {
                        _signInWithEmailAndPassword();
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'VisbyRoundCF',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
