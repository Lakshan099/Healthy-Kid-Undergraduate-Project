import 'package:flutter/material.dart';
import 'package:healthy_kid_app/components/NavBar.dart';
import 'package:healthy_kid_app/sendMsg/body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QandAScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          AppLocalizations.of(context)!.chworker,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 205, 130),
      ),
      body: QandA(),
    );
  }
}
