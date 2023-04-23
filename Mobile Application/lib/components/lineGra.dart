import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';

class LineChartScreen extends StatelessWidget {
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('chartData');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: dataCollection.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final data = snapshot.data!.docs.map((doc) {
          final x = doc['x'];
          final y = doc['y'];
          return DataPoint(x, y);
        }).toList();
        final series = [
          charts.Series<DataPoint, int>(
            id: 'Data',
            domainFn: (DataPoint point, _) => point.x,
            measureFn: (DataPoint point, _) => point.y,
            data: data,
          ),
        ];
        return charts.LineChart(series);
      },
    );
  }
}

class DataPoint {
  final int x;
  final int y;

  DataPoint(this.x, this.y);
}
