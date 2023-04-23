import 'package:collection/collection.dart';
import 'package:healthy_kid_app/Screens/home_screen.dart';

class BMIPoint {
  final double x;
  final double y;
  BMIPoint({required this.x, required this.y});
}

List<BMIPoint> get BMIValues {
  final data = <double>[3, 4, 6, 11, 3, 6, 4];
  /*final data = <double>[
    double.parse(HomeScreen.BMIval[0]!),
    double.parse(HomeScreen.BMIval[1]!),
    double.parse(HomeScreen.BMIval[2]!),
    double.parse(HomeScreen.BMIval[3]!),
    double.parse(HomeScreen.BMIval[4]!),
    double.parse(HomeScreen.BMIval[5]!),
    double.parse(HomeScreen.BMIval[6]!)
  ];*/
  return data
      .mapIndexed(
          ((index, element) => BMIPoint(x: index.toDouble(), y: element)))
      .toList();
}
