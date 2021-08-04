import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:just_chat/components/google_sign_in.dart';
import 'homepage.dart';

class EmailSignUp extends StatefulWidget {
  const EmailSignUp({Key key}) : super(key: key);

  @override
  _EmailSignUpState createState() => _EmailSignUpState();
}

var GlobalNameOfUser;

class _EmailSignUpState extends State<EmailSignUp> {
  void registerToFb() {
    firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      dbRef.child(result.user.uid).set({
        "email": emailController.text,
        "age": ageController.text,
        "name": nameController.text
      }).then((res) {
        currentUserId = result.user.uid;
        print("=====================$currentUserId========================");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    currentUserId: result.user.uid,
                  )),
        );
      });
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.blue[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 20, bottom: 10),
                  child: ElevatedButton(
                    child: Text("OK"),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.blue))),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        elevation: MaterialStateProperty.all(5)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              ],
            );
          });
    });
  }

  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("Users");
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  InputDecoration inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.black12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Sign Up")),
        backgroundColor: Colors.blue[50],
        key: _formKey,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 1.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue[100],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: MediaQuery.of(context).size.height / 8,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30, top: 30),
                      child: Image.asset("assets/images/tutorhub_logo.PNG"),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: MediaQuery.of(context).size.height / 12,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        style: TextStyle(fontFamily: "VisbyRoundCF"),
                        autofocus: true,
                        controller: emailController,
                        decoration: inputDecoration("Email"),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value != null) {
                            return 'Enter User Email';
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
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        style: TextStyle(fontFamily: "VisbyRoundCF"),
                        autofocus: true,
                        controller: nameController,
                        decoration: inputDecoration("Username"),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value != null) {
                            return 'Enter User Name';
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
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        style: TextStyle(fontFamily: "VisbyRoundCF"),
                        controller: passwordController,
                        autofocus: true,
                        obscureText: true,
                        decoration: inputDecoration("Password"),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value != null) {
                            return 'Enter Password';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 25),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width / 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        registerToFb();
                      },
                      child: Text('Submit'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
