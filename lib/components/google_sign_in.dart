import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:just_chat/models/user.dart';
import 'package:just_chat/pages/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'body_progress.dart';

bool loading = true;
DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("Users");
final FirebaseAuth auth = FirebaseAuth.instance;
GoogleSignIn googleHomePageUserSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
    // 'https://www.googleapis.com/auth/cloud-platform',
  ],
);
String currentUserId = '';

Future<void> handleGetContact(GoogleSignInAccount user) async {
  final http.Response response = await http.get(
    Uri.parse('https://people.googleapis.com/v1/people/me/connections'
        '?requestMask.includeField=person.names'),
    headers: await user.authHeaders,
  );
  final Map<String, dynamic> data = json.decode(response.body);
  //Will be using it later. !!!DO NOT DELETE!!!
}

handleLoading() async {
  loading = true;
}

void handleSignIn(BuildContext context) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loading = true;
    await googleHomePageUserSignIn.signIn();
    GoogleSignInAccount googleSignInAccount =
        await googleHomePageUserSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    // login();
    OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    // String credentialText = credential.toString();
    UserCredential authResult = await auth.signInWithCredential(credential);
    User firebaseUser = authResult.user;
    dbRef.child(authResult.user.uid).set({
      "user email": firebaseUser.email,
      // "credential": credentialText,
      "name": firebaseUser.displayName,
      "uid": authResult.user.uid
    });

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        // Update data to server if new user
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set({
          'nickname': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoURL,
          'id': firebaseUser.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null
        });

        // Write data to local
        User currentUser = firebaseUser;
        await prefs?.setString('id', currentUser.uid);
        await prefs?.setString('nickname', currentUser.displayName ?? "");
        await prefs?.setString('photoUrl', currentUser.photoURL ?? "");
      } else {
        DocumentSnapshot documentSnapshot = documents[0];
        UserChat userChat = UserChat.fromDocument(documentSnapshot);
        // Write data to local
        await prefs?.setString('id', userChat.id);
        await prefs?.setString('nickname', userChat.nickname);
        await prefs?.setString('photoUrl', userChat.photoUrl);
        await prefs?.setString('aboutMe', userChat.aboutMe);
      }
    }
    currentUserId = authResult.user.uid;
    loading = false;
    loading
        ? bodyProgress
        : Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                currentUserId: prefs.getString('id') ?? "",
              ),
            ),
          );
  } catch (error) {
    loading = false;
    print(error);
  }
}

void handleSignOut() => googleHomePageUserSignIn.disconnect();
