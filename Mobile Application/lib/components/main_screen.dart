import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:healthy_kid_app/Screens/check_screen.dart';
import 'package:healthy_kid_app/Screens/home_screen.dart';
import 'package:healthy_kid_app/Screens/profile_screen.dart';
import 'package:healthy_kid_app/Screens/upcoming_screen.dart';
import 'package:healthy_kid_app/calander/screens/calander.dart';
import 'package:line_icons/line_icons.dart';

class MainScreen extends StatefulWidget {
  static int? selectedIndex;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    Calander(),
    CheckScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _widgetOptions.elementAt(MainScreen.selectedIndex!),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: GNav(
              rippleColor: Colors.white,
              hoverColor: Colors.white,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Color.fromARGB(255, 134, 89, 151),
              color: Colors.black,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.syringe,
                  text: 'Upcoming',
                ),
                GButton(
                  icon: LineIcons.barChart,
                  text: 'Checking',
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                ),
              ],
              selectedIndex: MainScreen.selectedIndex!,
              onTabChange: (index) {
                setState(
                  () {
                    MainScreen.selectedIndex = index;
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
