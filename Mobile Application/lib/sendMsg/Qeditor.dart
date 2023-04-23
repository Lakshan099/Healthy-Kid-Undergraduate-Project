import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Qeditior extends StatefulWidget {
  const Qeditior({Key? key}) : super(key: key);

  @override
  State<Qeditior> createState() => _QeditiorState();
}

class _QeditiorState extends State<Qeditior> {
  String address = "";
  String pass = "";
  String uname = "";
  String date = DateFormat('yyy-MM-dd kk:mm').format(DateTime.now());
  final userAuth = FirebaseAuth.instance.currentUser!;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _mainController = TextEditingController();

  initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(213, 54, 53, 53),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(213, 54, 53, 53),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Color.fromARGB(255, 247, 246, 246)),
        title: Text(
          "Add a new Question",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Question',
              ),
              style: TextStyle(
                color: Color.fromARGB(255, 247, 246, 246),
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              date,
              style: TextStyle(
                color: Color.fromARGB(255, 247, 246, 246),
                fontWeight: FontWeight.normal,
                fontSize: 10,
              ),
            ),
            SizedBox(
              height: 28.0,
            ),
            TextField(
              controller: _mainController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              enabled: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Answer',
              ),
              style: TextStyle(
                color: Color.fromARGB(255, 247, 246, 246),
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 134, 89, 151),
        onPressed: () async {
          FirebaseFirestore.instance
              .collection("Q&A")
              .doc(_titleController.text)
              .set({
            "Email": userAuth.email.toString(),
            "Name": userAuth.displayName.toString(),
            "Location": address,
            "Message": _titleController.text,
            "date": date,
            "Reply": "Reply Message Pending...!"
          }).then((value) {
            //print(value.id);
            Navigator.pop(context);
          }).catchError((error) => print("Faild to add $error"));
        },
        child: Icon(Icons.send),
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
