import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:healthy_kid_app/Screens/CreateChildProfile_screen.dart';
import 'package:healthy_kid_app/components/BMI_Point.dart';
import 'package:healthy_kid_app/components/LineChart.dart';
import 'package:healthy_kid_app/components/NavBar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:healthy_kid_app/components/childData.dart';
import 'package:healthy_kid_app/components/notificationAPI.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class HomeScreen extends StatefulWidget {
  static String? nextName;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<double?> BMIval = [];
  String _selected = "0";
  String? name;
  String? cname;
  String? bmi;
  String? height;
  String? weight;
  String? bpm;
  String? child;
  String? fileName;
  String? imageUrl;
  final storageRef = FirebaseStorage.instance.ref();

  final user = FirebaseAuth.instance.currentUser!;

  var predValue = "";
  double? predValueD;

  @override
  void initState() {
    if (_selected == "0") {
      setDefalt();
      setDefaltG();
    }

    super.initState();
    predValue = "";
  }

  void predData() async {
    final interpreter = await Interpreter.fromAsset('neural/predmodel.tflite');
    var input = [
      [BMIval[1], BMIval[2], BMIval[3], BMIval[4], BMIval[5]]
    ];
    var output = List.filled(1, 0).reshape([1, 1]);
    interpreter.run(input, output);
    print(output[0][0]);

    this.setState(() {
      predValue = output[0][0].toString();
      predValueD = double.parse(predValue);
    });

    print("predValueD");
    print(predValueD);

    if (predValueD! <= 18.5) {
      ShowNotification(
          id: 0, title: "Underweight", body: "The child may be malnourished");
    } else if (predValueD! >= 18.5 && predValueD! <= 24.9) {
      ShowNotification(
          id: 1, title: "Normal weight", body: "The child is healthy");
    } else if (predValueD! >= 25 && predValueD! <= 29.9) {
      ShowNotification(
          id: 2,
          title: "Overweight",
          body: "The weight limit for the child's height is exceeded");
    } else {
      ShowNotification(id: 3, title: "Obesity", body: "The child was obese");
    }
  }

  /*getChildrenList() {
    int count = 0;
    print("getList");
    FirebaseFirestore.instance
        .collection('Child/' + user.email.toString() + '/Children')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        print(doc.id);
        Map a = {
          'id': count.toString(),
          'image': doc["ImgURL"],
          'name': doc.id
        };
        _childList.add(a);
        count++;
      });
      Map newchild = {
        'id': count.toString(),
        'image': 'assets/images/childP.png',
        'name': 'Create Child Profile'
      };
      _childList.add(newchild);
      print(_childList);
    });
    setState(() {});
  }

  Future getChildData() async {
    await FirebaseFirestore.instance
        .collection('Child')
        .doc(user.toString())
        .collection('Children')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["Name"]);
      });
    });
  }

  List<Map> _childList = [];*/

  @override
  Widget build(BuildContext context) {
    var imageList = [
      "assets/images/L3.png",
      "assets/images/L1.png",
      "assets/images/L2.png",
    ];

    var stat = [
      "${AppLocalizations.of(context)!.weight}",
      "${AppLocalizations.of(context)!.height}",
      "${AppLocalizations.of(context)!.bpm}",
    ];

    var scale = ["${weight} kg", "${height} cm", "${bpm} bpm"];

    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          AppLocalizations.of(context)!.home,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 205, 130),
      ),
      backgroundColor: Color.fromARGB(255, 255, 205, 130),
      body: Container(
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(239, 239, 239, 239),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(width: 2, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection(
                                'Child/' + user.email.toString() + '/Children')
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<DropdownMenuItem> clientItems = [];
                          if (!snapshot.hasData) {
                            const CircularProgressIndicator();
                          } else {
                            final clients =
                                snapshot.data?.docs.reversed.toList();
                            clientItems.add(
                              DropdownMenuItem(
                                value: "0",
                                child: Row(
                                  children: [
                                    SizedBox(width: 12),
                                    Text('Select Child')
                                  ],
                                ),
                              ),
                            );

                            for (var client in clients!) {
                              clientItems.add(
                                DropdownMenuItem(
                                  value: client.id,
                                  child: Row(
                                    children: [
                                      SizedBox(width: 12),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          client['imgURL'],
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(
                                          client['Name'],
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                          }
                          return Container(
                            width: 340.0,
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                child: DropdownButton(
                                  items: clientItems,
                                  onChanged: (clientValue) {
                                    setState(() {
                                      _selected = clientValue;

                                      if (_selected == "0") {
                                        setDefalt();
                                        setDefaltG();
                                      } else {
                                        getChildName(clientValue);
                                        getHRepo(cname.toString());
                                        HomeScreen.nextName = cname.toString();
                                        getBMIvalues();
                                        predData();
                                      }
                                    });
                                    print(clientValue);
                                  },
                                  value: _selected,
                                  isExpanded: false,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 100),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Text(
                            AppLocalizations.of(context)!.bmi,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      AspectRatio(
                        aspectRatio: 2,
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                  spots: [
                                    FlSpot(1, BMIval[1]!),
                                    FlSpot(2, BMIval[2]!),
                                    FlSpot(3, BMIval[3]!),
                                    FlSpot(4, BMIval[4]!),
                                    FlSpot(5, BMIval[5]!),
                                  ],
                                  isCurved: false,
                                  dotData: FlDotData(show: true))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 45, right: 45, top: 200),
                  child: Text(
                    AppLocalizations.of(context)!.statics + ChildData.height,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 450),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      for (int i = 0; i < 3; i++)
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.only(left: 10),
                          width: MediaQuery.of(context).size.width / 1.5,
                          height: MediaQuery.of(context).size.height / 5.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                                offset: Offset(8, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    stat[i],
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    scale[i],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 110, top: 5),
                                    child: Image.asset(
                                        'assets/images/Arrow_1.png'),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 35, right: 20),
                                child: Image.asset(
                                  imageList[i],
                                  height: 80,
                                  width: 80,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getChild(String childName) async {
    await FirebaseFirestore.instance
        .collection("Child_Health")
        .doc(user.email.toString())
        .collection("Children")
        .where("name", isEqualTo: childName)
        .snapshots()
        .listen((event) {
      setState(() {
        final cnname = [];
        final cbmi = [];
        final cheight = [];
        final cweight = [];
        final cbpm = [];

        for (var doc in event.docs) {
          cnname.add(doc.data()["name"]);
          cbmi.add(doc.data()["BMI"]);
          cheight.add(doc.data()["Height"]);
          cweight.add(doc.data()["Weight"]);
          cbpm.add(doc.data()["BPM"]);
        }

        print("Name: ${cnname.join(", ")}");
        print("BMI: ${cbmi.join(", ")}");
        print("Height: ${cheight.join(", ")}");
        print("Weight: ${cweight.join(", ")}");
        print("BPM: ${cbpm.join(", ")}");
        child = cnname.join(", ");
        bmi = cbmi.join(", ");
        height = cheight.join(", ");
        weight = cweight.join(", ");
        bpm = cbpm.join(", ");
        print(child);
      });
    });
  }

  void getHRepo(String childN) async {
    await FirebaseFirestore.instance
        .collection('Child_Health')
        .doc(user.email.toString())
        .collection('Children')
        .doc(childN)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        setState(() {
          child = documentSnapshot['name'];
          bmi = documentSnapshot['BMI'];
          height = documentSnapshot['Height'];
          weight = documentSnapshot['Weight'];
          bpm = documentSnapshot['BPM'];
        });
        //print(cname);
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void getChildName(String docVal) async {
    await FirebaseFirestore.instance
        .collection('Child')
        .doc(user.email.toString())
        .collection('Children')
        .doc(docVal)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        //print('Document data: ${documentSnapshot.data()}');
        setState(() {
          cname = documentSnapshot['Name'];
        });
        //print(cname);
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void getBMIvalues() async {
    int i = 0;
    await FirebaseFirestore.instance
        .collection('Health_Reports')
        .where("Email", isEqualTo: user.email.toString())
        .where("ChildName", isEqualTo: cname)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          //print(doc["bmi"]);
          BMIval.insert(i, double.parse(doc["bmi"]));
          i++;
        });
      });
    });
  }

  void setDefalt() async {
    setState(() {
      child = "";
      bmi = "0";
      height = "0";
      weight = "0";
      bpm = "0";
    });
  }

  void setDefaltG() async {
    setState(() {
      for (int i = 0; i < 20; i++) {
        BMIval.insert(i, double.parse("0"));
      }
    });
  }
}
