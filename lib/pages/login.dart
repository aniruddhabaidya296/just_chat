import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:just_chat/components/body_progress.dart';
import 'package:just_chat/components/google_sign_in.dart';
import 'email_login.dart';
import 'email_sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }, child: Builder(builder: (context) {
      return Scaffold(
          backgroundColor: Colors.red[100],
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Welcome"),
          ),
          body: Center(
            child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: SignInButton(
                          Buttons.Email,
                          text: "Sign in with Email",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EmailLogIn()),
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.only(left: 50),
                          elevation: 10,
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: SignInButton(
                          Buttons.Google,
                          text: "Sign In with Google",
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) => bodyProgress);

                            handleSignIn(context);
                          },
                          padding: EdgeInsets.only(left: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 10,
                        )),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: GestureDetector(
                            child: Text("Sign Up",
                                style: TextStyle(
                                    fontFamily: 'VisbyRoundCF',
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    color: Colors.red)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EmailSignUp()),
                              );
                            }))
                  ]),
            ),
          ));
    }));
  }
}
