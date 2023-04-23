import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_kid_app/Screens/home_screen.dart';
import 'package:healthy_kid_app/components/CircleProgress.dart';
import 'package:healthy_kid_app/components/NavBar.dart';
import 'package:healthy_kid_app/components/QR_Code.dart';
import 'package:healthy_kid_app/components/main_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:healthy_kid_app/components/notificationAPI.dart';

class CheckScreen extends StatefulWidget {
  @override
  _CheckScreenState createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen>
    with SingleTickerProviderStateMixin {
  String height = "";
  String weight = "";
  String bpm = "";
  String year = DateFormat('yyy').format(DateTime.now());
  String month = DateFormat('MM').format(DateTime.now());
  String date = DateFormat('dd').format(DateTime.now());
  String date1 = DateFormat('yyy-MM-dd').format(DateTime.now());
  String time = DateFormat().format(DateTime.now());
  String? cname = HomeScreen.nextName;
  String birthday = "";
  String gender = "";
  String age = "";
  String child = "";
  String address = "";
  String pass = "";
  String uname = "";
  String bmiA = "";
  String st = "";

  final userAuth = FirebaseAuth.instance.currentUser!;

  late AnimationController _animationController;
  late Animation<double> _animation;
  final maxProgress = 100.0;

  @override
  void initState() {
    if (ScanQrPage.deviceId == null) {
      ///Show msg

      print(ScanQrPage.deviceId);
      MainScreen.selectedIndex = 2;
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Add Device"),
            content: Text("Add device to view data"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScanQrPage(),
                      ),
                    );
                  },
                  child: Text("Add Device"))
            ],
          ),
        );
      });

      
    }

    CheckHeight();
    CheckWeight();
    CheckBPM();
    getUser();
    getChild();
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));

    _animation =
        Tween<double>(begin: 0, end: maxProgress).animate(_animationController)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          AppLocalizations.of(context)!.check,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 205, 130),
      ),
      backgroundColor: Color.fromARGB(255, 255, 205, 130),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 4,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              AppLocalizations.of(context)!.cheigh,
                              style: TextStyle(
                                fontSize: 20.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              AppLocalizations.of(context)!.height,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              height + " cm",
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40, right: 20),
                        child: Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(30),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: InkWell(
                            splashColor: Colors.black26,
                            onTap: () {
                              height = "0";
                              FirebaseDatabase.instance
                                  .ref('Devices/' +
                                      ScanQrPage.deviceId! +
                                      '/SensorValues/height')
                                  .set(height)
                                  .then((_) {})
                                  .catchError((error) {});
                            },
                            child: Image.asset(
                              'assets/images/radio-on-button 1.png',
                              height: 80,
                              width: 80,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 4,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              AppLocalizations.of(context)!.cweight,
                              style: TextStyle(
                                fontSize: 20.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              AppLocalizations.of(context)!.weight,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              weight + " kg",
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40, right: 20),
                        child: Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(30),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: InkWell(
                            splashColor: Colors.black26,
                            onTap: () {
                              weight = "0";
                              FirebaseDatabase.instance
                                  .ref('Devices/' +
                                      ScanQrPage.deviceId! +
                                      '/SensorValues/weight')
                                  .set(height)
                                  .then((_) {})
                                  .catchError((error) {});
                            },
                            child: Image.asset(
                              'assets/images/radio-on-button 1.png',
                              height: 80,
                              width: 80,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ////////////////////////
              ///
              ///

              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.1,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              AppLocalizations.of(context)!.cbpm,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, top: 20),
                              child: Center(
                                child: Row(
                                  children: [
                                    CustomPaint(
                                      foregroundPainter:
                                          CircleProgress(_animation.value),
                                      child: Container(
                                        width: 200,
                                        height: 200,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {},
                                              child: Center(
                                                child: Text(
                                                  bpm,
                                                  //'${_animation.value.toInt()}',
                                                  style:
                                                      TextStyle(fontSize: 50),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20),
                                              child: Text(
                                                " BPM",
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey,
                                                ),
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
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 80,
                                right: 80,
                              ),
                              child: Material(
                                color: Color.fromARGB(255, 134, 89, 151),
                                borderRadius: BorderRadius.circular(30),
                                child: InkWell(
                                  onTap: () {
                                    if (_animation.value == maxProgress) {
                                      _animationController.reverse();
                                      bpm = "0";
                                      FirebaseDatabase.instance
                                          .ref(
                                              'Devices/' +
                                              ScanQrPage.deviceId! +
                                              '/SensorValues/BPM')
                                          .set(height)
                                          .then((_) {})
                                          .catchError((error) {});
                                    } else {
                                      _animationController.forward();
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 30),
                                    child: Text(
                                      "Start",
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 80,
                  right: 80,
                ),
                child: Material(
                  color: Color.fromARGB(255, 134, 89, 151),
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () {
                      cheackStatus(double.parse(height), double.parse(weight));
                      addChildMediRecord(
                          height,
                          weight,
                          bpm,
                          userAuth.email.toString(),
                          cname.toString(),
                          date,
                          month,
                          year,
                          time,
                          bmiA);
                      print(time);
                      addChildReport(
                          age,
                          cname.toString(),
                          st,
                          date1,
                          userAuth.email.toString(),
                          height,
                          address,
                          uname,
                          weight,
                          bpm,
                          bmiA);

                      //ShowNotification(id: 0, title: "Test", body: "Test low");
                      AwesomeDialog(
                          context: context,
                          animType: AnimType.leftSlide,
                          headerAnimationLoop: false,
                          dialogType: DialogType.success,
                          showCloseIcon: true,
                          title: 'Succes',
                          desc: 'Health Record Added',
                          btnOkOnPress: () {
                            MainScreen.selectedIndex = 2;
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
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      child: Text(
                        "Add Health Record",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> CheckHeight() async {
    String data = "";
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('Devices/' + ScanQrPage.deviceId! + '/SensorValues/height');
    starCountRef.onValue.listen((DatabaseEvent event) {
      data = event.snapshot.value.toString();
      setState(() {
        height = data;
      });
    });
  }

  Future<void> CheckWeight() async {
    String data = "";
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('Devices/' + ScanQrPage.deviceId! + '/SensorValues/weight');
    starCountRef.onValue.listen((DatabaseEvent event) {
      data = event.snapshot.value.toString();
      setState(() {
        weight = data;
      });
    });
  }

  Future<void> CheckBPM() async {
    String data = "";
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('Devices/' + ScanQrPage.deviceId! + '/SensorValues/BPM');
    starCountRef.onValue.listen((DatabaseEvent event) {
      data = event.snapshot.value.toString();
      setState(() {
        bpm = data;
      });
    });
  }

  CollectionReference childData =
      FirebaseFirestore.instance.collection('Child_Health');

  Future<void> addChildMediRecord(
      String height,
      String weight,
      String bpm,
      String user,
      String name,
      String date,
      String month,
      String year,
      String time,
      String bmi) {
    return childData
        .doc(user)
        .collection('Children')
        .doc(name)
        .set({
          'name': name,
          'Height': height,
          'Weight': weight,
          'BPM': bpm,
          'Date': date,
          'Month': month,
          'Year': year,
          'Time': time,
          "BMI": bmi
        })
        .then((value) => print("Record Add"))
        .catchError((error) => print("Faild to add child: $error"));
  }

  CollectionReference cReport =
      FirebaseFirestore.instance.collection('Health_Reports');

  Future<void> addChildReport(
      String cage,
      String cname,
      String st,
      String date,
      String email,
      String height,
      String location,
      String uname,
      String weight,
      String bpm,
      String bmi) {
    return cReport
        .doc()
        .set({
          'ChildAge': cage,
          'ChildName': cname,
          'CurrentSt': st,
          'Date': date,
          'Email': email,
          'Height': height,
          'Location': location,
          'Name': uname,
          'Weight': weight,
          'bpm': bpm,
          'bmi': bmi
        })
        .then((value) => print("Record Add"))
        .catchError((error) => print("Faild to add repo: $error"));
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

  void getChild() async {
    await FirebaseFirestore.instance
        .collection("Child")
        .doc(userAuth.email.toString())
        .collection("Children")
        .where("Name", isEqualTo: cname)
        .snapshots()
        .listen((event) {
      final cname = [];
      final cage = [];
      final cgender = [];
      final cBday = [];
      for (var doc in event.docs) {
        cname.add(doc.data()["Name"]);
        cage.add(doc.data()["Age"]);
        cgender.add(doc.data()["Gender"]);
        cBday.add(doc.data()["BirthDay"]);
      }
      setState(() {
        print("Name: ${cname.join(", ")}");
        print("Age: ${cage.join(", ")}");
        print("Gender: ${cgender.join(", ")}");
        print("BirthDay: ${cBday.join(", ")}");
        child = cname.join(", ");
        age = cage.join(", ");
        gender = cgender.join(", ");
        birthday = cBday.join(", ");
        print(child);
      });
    });
  }

  void cheackStatus(double h, double w) {
    double bmi = 0;

    bmi = (w / (h * h));
    bmiA = bmi.toString();

    if (bmi <= 18.5) {
      st = "Underweight";
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      st = "Normal weight";
    } else if (bmi >= 25 && bmi <= 29.9) {
      st = "Overweight";
    } else {
      st = "Obesity";
    }

    print(st);
  }
}
