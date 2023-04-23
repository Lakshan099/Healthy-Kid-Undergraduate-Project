import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Qreader extends StatefulWidget {
  Qreader(this.doc, {Key? key}) : super(key: key);
  QueryDocumentSnapshot doc;
  @override
  State<Qreader> createState() => _QreaderState();
}

class _QreaderState extends State<Qreader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(213, 54, 53, 53),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(213, 54, 53, 53),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.doc["Message"],
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
              widget.doc["date"],
              style: TextStyle(
                color: Color.fromARGB(255, 247, 246, 246),
                fontWeight: FontWeight.normal,
                fontSize: 10,
              ),
            ),
            SizedBox(
              height: 28.0,
            ),
            Text(
              widget.doc["Reply"],
              style: TextStyle(
                color: Color.fromARGB(255, 247, 246, 246),
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
