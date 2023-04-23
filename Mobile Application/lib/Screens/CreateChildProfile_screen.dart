import 'dart:io';
import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:healthy_kid_app/components/main_screen.dart';
import 'package:intl/intl.dart';

class CreateChildProfileScreen extends StatefulWidget {
  @override
  _CreateChildProfileScreenState createState() =>
      _CreateChildProfileScreenState();
}

class _CreateChildProfileScreenState extends State<CreateChildProfileScreen> {
  int? _value = 0;
  String? gender;
  String imageUrl = '';

  final user = FirebaseAuth.instance.currentUser!;

  final TextEditingController NameController = TextEditingController();

  final TextEditingController _date = TextEditingController();

  final TextEditingController age = TextEditingController();

  PlatformFile? pikedFile;

  Future uploadFile() async {
    final path =
        'files/childImg/${user.email.toString()}/${NameController.text}/${pikedFile!.name}';
    final file = File(pikedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    try {
      await ref.putFile(file);
      imageUrl = await ref.getDownloadURL();
      print(imageUrl);
    } catch (error) {
      //Some error occurred
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pikedFile = result.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/logo1.png",
                    height: 100,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Create Child Profile',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Create new profile',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      CircleAvatar(
                          radius: 71,
                          backgroundColor: Color.fromARGB(255, 134, 89, 151),
                          child: CircleAvatar(
                            radius: 65,
                            backgroundImage: pikedFile == null
                                ? null
                                : FileImage(
                                    File(pikedFile!.path!),
                                  ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 120, top: 90),
                        child: RawMaterialButton(
                          elevation: 10,
                          fillColor: Color.fromARGB(255, 134, 89, 151),
                          child: Icon(Icons.add_a_photo),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                          onPressed: selectFile,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.only(top: 3, left: 6, right: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: NameController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      //border: InputBorder.none,
                      contentPadding: EdgeInsets.all(0),
                      hintStyle: TextStyle(
                        height: 1,
                      ),
                      icon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.only(top: 3, left: 6, right: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.boy_rounded,
                        color: Colors.black,
                      ),
                      Radio(
                        value: 0,
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = value;
                          });
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text('Male'),
                      Radio(
                        value: 1,
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = value;
                          });
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text('Female'),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.only(top: 3, left: 6, right: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _date,
                    decoration: const InputDecoration(
                      hintText: 'BirthDay',
                      //border: InputBorder.none,
                      contentPadding: EdgeInsets.all(0),
                      hintStyle: TextStyle(
                        height: 1,
                      ),
                      icon: Icon(
                        Icons.calendar_month,
                        color: Colors.black,
                      ),
                      //labelText: "Select Birthday",
                    ),
                    onTap: () async {
                      DateTime? pickeddate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickeddate != null) {
                        setState(() {
                          _date.text =
                              DateFormat('yyyy-MM-dd').format(pickeddate);
                        });
                      }
                    },
                  ),
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.only(top: 3, left: 6, right: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: age,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: const InputDecoration(
                      hintText: 'Age',
                      //border: InputBorder.none,
                      contentPadding: EdgeInsets.all(0),
                      hintStyle: TextStyle(
                        height: 1,
                      ),
                      icon: Icon(
                        Icons.accessibility,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    color: Color.fromARGB(255, 134, 89, 151),
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () async {
                        await uploadFile();
                        print("pop up closed");
                        if (_value == 0) {
                          gender = 'Male';
                        } else {
                          gender = 'Female';
                        }
                        addChild(
                            NameController.text,
                            gender.toString(),
                            _date.text,
                            age.text,
                            user.email.toString(),
                            imageUrl);

                        addChildName(NameController.text);

                        AwesomeDialog(
                          context: context,
                          animType: AnimType.leftSlide,
                          headerAnimationLoop: false,
                          dialogType: DialogType.success,
                          showCloseIcon: true,
                          title: 'Succes',
                          desc: 'Child Profile Created',
                          btnOkOnPress: () {
                            MainScreen.selectedIndex = 0;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainScreen(),
                              ),
                            );
                          },
                          btnOkIcon: Icons.check_circle,
                          onDismissCallback: (type) {
                            debugPrint('Dialog Dissmiss from callback $type');
                          },
                        ).show();
                      },
                      child: Container(
                        //alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                        child: Text(
                          "Create",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

CollectionReference users = FirebaseFirestore.instance.collection('Child');

Future<void> addChild(String Name, String Gender, String BirthDay, String Age,
    String user, String imgURL) {
  return users
      .doc(user)
      .collection('Children')
      .doc()
      .set({
        'Name': Name,
        'Gender': Gender,
        'BirthDay': BirthDay,
        'Age': Age,
        'imgURL': imgURL
      })
      .then((value) => print("User Add"))
      .catchError((error) => print("Faild to add child: $error"));
}

CollectionReference child = FirebaseFirestore.instance.collection('ChildCount');

Future<void> addChildName(String Name) {
  return child
      .doc()
      .set({
        'name': Name,
      })
      .then((value) => print("Child nameAdd"))
      .catchError((error) => print("Faild to add child: $error"));
}
