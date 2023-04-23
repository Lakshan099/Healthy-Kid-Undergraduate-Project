import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class detailscreen extends StatefulWidget {
  final title;
  final imagedata;
  final decription;
  final date;

  const detailscreen(
      {super.key,
      required this.title,
      required this.imagedata,
      required this.decription,
      required this.date});

  @override
  State<detailscreen> createState() => _detailscreenState();
}

class _detailscreenState extends State<detailscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor:  Color.fromARGB(255, 255, 205, 130),
      ),
      body: ListView(
        children: [
          Image.network(
            widget.imagedata,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    widget.date.toString().replaceRange(15, 30, ''),
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                  ),
                ),
                Text(
                  widget.decription.toString(),
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
