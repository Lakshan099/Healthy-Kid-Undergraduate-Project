import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_kid_app/Screens/Myprofile_screen.dart';
import 'package:healthy_kid_app/Screens/chat_inbox_screen.dart';
import 'package:healthy_kid_app/Screens/child_profile_screen.dart';
import 'package:healthy_kid_app/Screens/neuralNetwork.dart';
import 'package:healthy_kid_app/Screens/repo.dart';
import 'package:healthy_kid_app/Screens/report_screen.dart';
import 'package:healthy_kid_app/Screens/setting_screen.dart';
import 'package:healthy_kid_app/calander/screens/calander.dart';
import 'package:healthy_kid_app/components/LineChart.dart';
import 'package:healthy_kid_app/components/LiveChart.dart';
import 'package:healthy_kid_app/components/NavBar.dart';
import 'package:healthy_kid_app/components/RSSfeed.dart';
import 'package:healthy_kid_app/components/lineGra.dart';
import 'package:healthy_kid_app/sendMsg/Q&A_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:photo_view/photo_view.dart';

final Uri _url = Uri.parse(
  'https://www.epid.gov.lk/web/images/pdf/Immunization/nis_final_03_05_2017.jpg',
);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  initState() {
    getUser();
    super.initState();
  }

  String? uname;
  String _selected = "0";
  String name = "";
  String cname = "";
  String bmi = "";
  String height = "";
  String weight = "";
  String bpm = "";
  String child = "";
  String fileName = "";
  String imageUrl = "";
 String id="";

  final userAuth = FirebaseAuth.instance.currentUser!;

  List<Map> _childList = [
    {'id': '0', 'image': 'assets/images/c2.png', 'name': 'Ravidu Nethsara'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 205, 130),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10 * 24,
                  child: Stack(
                    children: <Widget>[
                      ClipPath(
                        clipper: CustomShape(),
                        child: Container(
                          height: 10 * 15,
                          color: Color.fromARGB(255, 255, 205, 130),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            SizedBox(height: 15),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              height: 10 * 14,
                              width: 10 * 14,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 10 * 0.6,
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      'assets/images/user.png'),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 100, top: 70),
                                child: SizedBox(
                                  child: InkWell(
                                    onTap: () {},
                                    child: Image.asset(
                                      'assets/images/camera.png',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              uname.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10 / 2),
                            Text(
                              userAuth.email.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 132, 146, 161),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ProfileMenuItem(
                  iconSrc: "assets/images/user1.png",
                  title: AppLocalizations.of(context)!.myprofile,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyProfileScreen()),
                    );
                  },
                ),
                ProfileMenuItem(
                  iconSrc: "assets/images/phone-call.png",
                  title: AppLocalizations.of(context)!.chworker,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QandAScreen()),
                    );
                  },
                ),
                ProfileMenuItem(
                  iconSrc: "assets/images/health-care.png",
                  title: AppLocalizations.of(context)!.vhprac,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RSSFeed(title: AppLocalizations.of(context)!.vhprac)),
                    );
                  },
                ),
                ProfileMenuItem(
                  iconSrc: "assets/images/medical-report.png",
                  title: AppLocalizations.of(context)!.vhrepo,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Repo()),
                    );
                  },
                ),
                ProfileMenuItem(
                  iconSrc: "assets/images/herbal.png",
                  title: AppLocalizations.of(context)!.mediDietary,
                  press: () {
                    
                    Navigator.of(context).push(
           PageRouteBuilder(
                opaque: true,
                barrierDismissible:true,
                pageBuilder: (BuildContext context, _, __) {
                  return Hero(
                      tag: "zoom",
                      child: Image.asset('assets/images/heData.jpg'),
                    );
                }
            )
        );
                  },
                ),
                ProfileMenuItem(
                  iconSrc: "assets/images/settings.png",
                  title: AppLocalizations.of(context)!.setting,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          AppLocalizations.of(context)!.vcpro,
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
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
                              .collection('Child/' +
                                  userAuth.email.toString() +
                                  '/Children')
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
                                          borderRadius:
                                              BorderRadius.circular(50),
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
                                      setState(() async {
                                        _selected = clientValue;
                                        id=clientValue;
                                        getChildName(clientValue);
                                        getChild(cname);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChildProfileScreen(
                                                      clientValue: id)),
                                        );

                                        if (_selected == 0) {}
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
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
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
      for (var doc in event.docs) {
        print(userAuth.photoURL);
        print(userAuth.displayName);
        name.add(doc.data()["Name"]);
      }
      setState(() {
        print("Name: ${name.join(", ")}");
        uname = name.join(", ");
        print(uname);
      });
    });
  }

  void getChild(String childName) async {
    await FirebaseFirestore.instance
        .collection("Child_Health")
        .doc(userAuth.email.toString())
        .collection("Children")
        .where("name", isEqualTo: childName)
        .snapshots()
        .listen((event) {
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
      setState(() {
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

  void getChildName(String docVal) async {
    await FirebaseFirestore.instance
        .collection('Child')
        .doc(userAuth.email.toString())
        .collection('Children')
        .doc(docVal)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        //print('Document data: ${documentSnapshot.data()}');
        cname = documentSnapshot['Name'];
        fileName = documentSnapshot['fileName'];
        //print(cname);
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  

  
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
  
}



class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    Key? key,
    required this.iconSrc,
    required this.title,
    required this.press,
  }) : super(key: key);
  final String iconSrc, title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10 * 2, vertical: 8 * 2),
        child: Row(
          children: <Widget>[
            Image.asset(
              iconSrc,
              height: 30,
              width: 30,
            ),
            SizedBox(width: 5 * 2),
            Text(
              title,
              style: TextStyle(fontSize: 10 * 1.6, color: Colors.black),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 10 * 1.6,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
