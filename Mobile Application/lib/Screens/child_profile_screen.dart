import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_kid_app/Screens/profile_screen.dart';
import 'package:healthy_kid_app/Screens/setting_screen.dart';
import 'package:healthy_kid_app/components/main_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChildProfileScreen extends StatefulWidget {
  const ChildProfileScreen({Key? key, required this.clientValue})
      : super(key: key);
  final String clientValue;
  @override
  _ChildProfileScreenPageState createState() => _ChildProfileScreenPageState();
}

class _ChildProfileScreenPageState extends State<ChildProfileScreen> {
  bool showPassword = false;
  String? cname;
  String? fileName;
  String? age;
  String? birthday;
  String? gender;
  String? child;
  String? ImgURL;

  final userAuth = FirebaseAuth.instance.currentUser!;

  initState() {
    getChildName(widget.clientValue);
    print("name");
    print(widget.clientValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 205, 130),
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            MainScreenTap(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.vcpro,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
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
                          image: NetworkImage(ImgURL.toString()),
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
                  AppLocalizations.of(context)!.fname, "${child}", false),
              buildTextField(
                  AppLocalizations.of(context)!.gen, "${gender}", false),
              buildTextField(
                  AppLocalizations.of(context)!.bDay, "${birthday}", false),
              buildTextField(
                  AppLocalizations.of(context)!.age, "${age}", false),
              SizedBox(
                height: 35,
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
                    child: Text(AppLocalizations.of(context)!.close),
                  )
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

  void getChildName(String docVal) async {
    await FirebaseFirestore.instance
        .collection('Child')
        .doc(userAuth.email.toString())
        .collection('Children')
        .doc(docVal)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        setState(() {
          child = documentSnapshot['Name'];
          age = documentSnapshot['Age'];
          birthday = documentSnapshot['BirthDay'];
          gender = documentSnapshot['Gender'];
          ImgURL = documentSnapshot['imgURL'];

          print(cname);
        });
      } else {
        print('Document does not exist on the database');
      }
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
