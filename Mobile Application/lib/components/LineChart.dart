import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_kid_app/Screens/home_screen.dart';
import 'package:healthy_kid_app/components/BMI_Point.dart';

class LineChartWidget extends StatefulWidget {
  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
  final List<BMIPoint> points;
  const LineChartWidget(this.points, {Key? key}) : super(key: key);
}

class _LineChartWidgetState extends State<LineChartWidget> {
  final user = FirebaseAuth.instance.currentUser!;
  List<double?> BMIval = [];

  void initState() {
    setDefalt();
    getBMIvalues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(spots: [
              FlSpot(1, BMIval[1]!),
              FlSpot(2, BMIval[2]!),
              FlSpot(3, BMIval[3]!),
              FlSpot(4, BMIval[4]!),
              FlSpot(5, BMIval[5]!),
            ], isCurved: false, dotData: FlDotData(show: true))
          ],
        ),
      ),
    );
  }

  void getBMIvalues() async {
    int i=0;
    await FirebaseFirestore.instance
        .collection('Health_Reports')
        .where("Email", isEqualTo: user.email.toString())
        .where("ChildName", isEqualTo: HomeScreen.nextName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          print("asd");
          print(HomeScreen.nextName);
          print(doc["bmi"]);
          BMIval.insert(i, double.parse(doc["bmi"]));
          i++;
        });
      });
    });
  }

    void setDefalt() async {
    setState(() {
      BMIval.removeRange(0,8);
    });
  }
}
