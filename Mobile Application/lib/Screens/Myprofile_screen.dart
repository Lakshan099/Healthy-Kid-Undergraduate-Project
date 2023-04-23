import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_kid_app/Screens/profile_screen.dart';
import 'package:healthy_kid_app/Screens/setting_screen.dart';
import 'package:healthy_kid_app/components/main_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _EditMyProfileScreen createState() => _EditMyProfileScreen();
}

class _EditMyProfileScreen extends State<MyProfileScreen> {
  final userAuth = FirebaseAuth.instance.currentUser!;

  initState() {
    getUser();
    super.initState();
  }

  String? uname;
  String? pass;
  String? address;

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          AppLocalizations.of(context)!.myprofile,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 205, 130),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                AppLocalizations.of(context)!.prodetails,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10))
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/a5.jpg'),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Color.fromARGB(255, 134, 89, 151),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              buildTextField(
                  AppLocalizations.of(context)!.fname, "${uname}", false),
              buildTextField(AppLocalizations.of(context)!.email,
                  "${userAuth.email.toString()}", false),
              buildTextField(
                  AppLocalizations.of(context)!.location, "${address}", false),
              SizedBox(
                height: 110,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.close,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }

  void getUser() async {
    await FirebaseFirestore.instance
        .collection("User")
        .where("Email", isEqualTo: userAuth.email.toString())
        .snapshots()
        .listen((event) {
      final name = [];
      final password = [];
      final location = [];
      for (var doc in event.docs) {
        name.add(doc.data()["Name"]);
        password.add(doc.data()["Password"]);
        location.add(doc.data()["Address"]);
      }
      setState(() {
        print("Name: ${name.join(", ")}");
        print("Password: ${password.join(", ")}");
        print("Address: ${location.join(", ")}");
        uname = name.join(", ");
        pass = password.join(", ");
        address = location.join(", ");
        print(uname);
      });
    });
  }
}

void MainScreenTap(BuildContext context) {
  MainScreen.selectedIndex = 3;
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => MainScreen(),
    ),
  );
}
