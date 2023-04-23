import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/main_screen.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin(BuildContext context) async {
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    //Check user account existance
    final cuser = FirebaseAuth.instance.currentUser;
    print(cuser);

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(cuser!.uid)
        .get()
        .then((value) async {
      if (value.exists) {
        print("Exist");

        notifyListeners();
        var document = value.data();
      } else {
        print("No Exist");
        MainScreen.selectedIndex = 0;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
          (Route<dynamic> route) => false,
        );
        print(cuser.displayName);

        notifyListeners();
      }
    });
  }

  //Log Out
  Future googleLogOut() async {
    try {
      await googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
