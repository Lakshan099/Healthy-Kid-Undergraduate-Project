import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthy_kid_app/Screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final fromKey = GlobalKey<FormState>();
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  TextEditingController NameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController compasswordController = new TextEditingController();
  TextEditingController ValidatePass = new TextEditingController();
  TextEditingController CoValidatePass = new TextEditingController();

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
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/logo1.png",
                      height: 130,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Create new account',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(height: 3),
                  Container(
                    height: 60,
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
                      controller: NameController,
                      validator: (value) {
                        if (value != null &&
                            RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                .hasMatch(value)) {
                          return 'Enter valid name';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      decoration: const InputDecoration(
                        labelText: 'Name',
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
                    height: 60,
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
                          Icons.email,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
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
                      controller: phoneController,
                      validator: (value) {
                        if (value != null && value.length < 10) {
                          return 'Enter valid Number';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        //border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                        hintStyle: TextStyle(
                          height: 1,
                        ),
                        icon: Icon(
                          Icons.phone,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
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
                      controller: addressController,
                      validator: (value) {
                        if (value != null &&
                            RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                .hasMatch(value)) {
                          return 'Enter valid Address';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      obscureText: false,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        //border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                        hintStyle: TextStyle(
                          height: 1,
                        ),
                        icon: Icon(
                          Icons.location_city,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
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
                      obscureText: _obscureText1,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                _obscureText1 = !_obscureText1;
                              },
                            );
                          },
                          child: Icon(_obscureText1
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        labelText: 'Password',
                        //border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                        hintStyle: TextStyle(
                          height: 1,
                        ),
                        icon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
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
                      controller: compasswordController,
                      validator: (value) {
                        if (value != null && value.length < 7) {
                          return 'Enter min. 7 characters';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      obscureText: _obscureText2,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                _obscureText2 = !_obscureText2;
                              },
                            );
                          },
                          child: Icon(_obscureText2
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        labelText: 'Comfrim Password',
                        //border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                        hintStyle: TextStyle(
                          height: 1,
                        ),
                        icon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
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
                            if (passwordController.text ==
                                compasswordController.text) {
                              addUser(
                                  emailController.text,
                                  NameController.text,
                                  phoneController.text,
                                  addressController.text,
                                  passwordController.text,
                                  compasswordController.text);
                              signUp();

                              Future.delayed(
                                Duration.zero,
                                () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text("User Registration"),
                                      content: Text(NameController.text +
                                          " user account successfully registered"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen(),
                                              ),
                                            );
                                          },
                                          child: Text("Back to Login"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              showToast();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()),
                                (Route<dynamic> route) => false,
                              );
                            }
                          }
                        },
                        child: Container(
                          //alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 70),
                          child: Text(
                            "Sign Up",
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
              'All ready have account? ',
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text(
                'Login',
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

  Future signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}

CollectionReference users = FirebaseFirestore.instance.collection('User');

Future<void> addUser(String Email, String Name, String Phone, String Address,
    String Password, String ComPassword) {
  return users
      .doc(Email)
      .set({
        'Email': Email,
        'Name': Name,
        'Address': Address,
        'Phone': Phone,
        'Password': Password,
        'ComPassword': ComPassword
      })
      .then((value) => print("User Add"))
      .catchError((error) => print("Faild to add user: $error"));
}

void showToast() => Fluttertoast.showToast(
      msg: "Passwords not Match",
      fontSize: 18,
    );
