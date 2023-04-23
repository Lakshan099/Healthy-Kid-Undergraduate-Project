import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_kid_app/sendMsg/Qcard.dart';
import 'package:healthy_kid_app/sendMsg/Qeditor.dart';
import 'package:healthy_kid_app/sendMsg/Qreader.dart';

class QandA extends StatefulWidget {
  const QandA({Key? key}) : super(key: key);

  @override
  State<QandA> createState() => _QandAState();
}

class _QandAState extends State<QandA> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Messages",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("Q&A").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return GridView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        //crossAxisSpacing: 18,
                        // mainAxisSpacing: 18,
                      ),
                      children: snapshot.data!.docs
                          .map((note) => Qcard(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Qreader(note),
                                    ));
                              }, note))
                          .toList(),
                    );
                  }
                  return Text(
                    "No questions",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Qeditior()));
        },
        label: Text("Add Question"),
        backgroundColor: Color.fromARGB(255, 134, 89, 151),
        icon: Icon(Icons.add),
      ),
    );
  }
}
