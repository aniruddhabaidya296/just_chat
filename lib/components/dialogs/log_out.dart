import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_chat/components/size_config.dart';
import 'package:just_chat/pages/login.dart';

import '../google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

logOut(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            // backgroundColor: Colors.red[100],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text("Log Out"),
            content: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text("Are you sure you want to log out?"),
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      child: Text("Yes"),
                      onPressed: () async {
                        // profileDp = null;
                        final User user = await _auth.currentUser;

                        googleHomePageUserSignIn.signOut();
                        if (user != null) {
                          await _auth.signOut();
                          final String email = user.email;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text(email + ' has successfully signed out.'),
                          ));

                          Navigator.pushNamedAndRemoveUntil(
                              context, "/login", (route) => false);
                        }
                      },
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(color: Colors.red))),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          elevation: MaterialStateProperty.all(5)),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(color: Colors.red))),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          elevation: MaterialStateProperty.all(5)),
                    ),
                  ],
                )
              ],
            ),
          ));
}
