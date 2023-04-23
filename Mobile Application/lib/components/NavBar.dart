import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healthy_kid_app/Screens/CreateChildProfile_screen.dart';
import 'package:healthy_kid_app/Screens/FAQ_screen.dart';
import 'package:healthy_kid_app/Screens/home_screen.dart';
import 'package:healthy_kid_app/Screens/setting_screen.dart';
import 'package:healthy_kid_app/Screens/welcome_screen.dart';
import 'package:healthy_kid_app/components/QR_Code.dart';
import 'package:healthy_kid_app/components/main_screen.dart';
import 'package:healthy_kid_app/widget/language_picker_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              'Healthy Kid',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            accountEmail: Text(
              'IoT Based Smart Child Health Care System',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logoC1.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 205, 130),
              image: DecorationImage(
                image: AssetImage("assets/images/kids2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.qr_code),
            title: Text(AppLocalizations.of(context)!.add),
            onTap: () {
              MainScreen.selectedIndex = 0;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanQrPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text(AppLocalizations.of(context)!.ccp),
            onTap: () {
              MainScreen.selectedIndex = 0;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateChildProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(AppLocalizations.of(context)!.home),
            onTap: () {
              MainScreen.selectedIndex = 0;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text(AppLocalizations.of(context)!.fq),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FAQScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: LanguagePickerWidget(),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.setting),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(AppLocalizations.of(context)!.sout),
            onTap: () {
              FirebaseAuth.instance.signOut().then(
                    (value) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}
