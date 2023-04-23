import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthy_kid_app/Screens/forgot_password_screen.dart';
import 'package:healthy_kid_app/Screens/home_screen.dart';
import 'package:healthy_kid_app/components/childData.dart';
import 'package:healthy_kid_app/components/main_screen.dart';
import 'package:healthy_kid_app/Screens/signup_screen.dart';
import 'package:flutter/src/material/navigation_bar.dart';
import 'package:healthy_kid_app/components/main_screen.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final fromKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: fromKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/logo1.png",
                      height: 200,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Proceed with your',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 70,
                    padding: const EdgeInsets.only(top: 3, left: 6, right: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: emailController,
                      validator: (emailController) => emailController != null &&
                              !EmailValidator.validate(emailController)
                          ? 'Enter a valid email'
                          : null,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        //border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                        hintStyle: TextStyle(
                          height: 1,
                        ),
                        icon: Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    padding: const EdgeInsets.only(top: 3, left: 6, right: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value != null && value.length < 7) {
                          return 'Enter min. 7 characters';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        //border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),

                        hintStyle: TextStyle(
                          height: 1,
                        ),
                        icon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                _obscureText = !_obscureText;
                              },
                            );
                          },
                          child: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ForgotPasswordPage();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      color: Color.fromARGB(255, 134, 89, 151),
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        onTap: () {
                          final isValidFrom = fromKey.currentState!.validate();
                          if (isValidFrom) {
                            //checkuser(emailController.text,
                            // passwordController.text, context);
                            signUserIn();
                            
                            
                          }
                        },
                        child: Container(
                          //alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 70),
                          child: Text(
                            "Login",
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
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.white,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have an account? ',
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Color.fromARGB(255, 134, 89, 151),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future signUserIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        FirebaseFirestore.instance
            .collection('Child/' + emailController.text + '/Children')
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) async {
            print(doc.id);
            ChildData.childList.add(doc.id);
          });
          AwesomeDialog(
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            showCloseIcon: true,
            title: 'Succes',
            desc: 'You are successfully logged in',
            btnOkOnPress: () {
              MainScreen.selectedIndex = 0;
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
          
        }).onError((error, stackTrace) {
          print("Error ${error.toString()}");
          showToast();
        });
      });
    } on FirebaseAuthException catch (error) {
      print("Error ${error.toString()}");
       AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        headerAnimationLoop: false,
        title: 'Error',
        desc:
            'Invalid Login',
        btnOkOnPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        },
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red,
      ).show();

    }
  }

  void checkuser(String uname, String password, BuildContext context) async {
    bool exist = false;
    await FirebaseFirestore.instance
        .collection('User')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["Email"]);
        print(doc["Password"]);

        if (uname == doc["Email"] && password == doc["Password"]) {
          exist = true;
        }
      });
    });

    if (exist == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ),
      );
      print("done");
    } else {
      print("error");
      showToast();
    }
  }

  void showToast() => Fluttertoast.showToast(
        msg: "Invalid Login",
        fontSize: 18,
      );
}
