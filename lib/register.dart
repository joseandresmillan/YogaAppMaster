import 'dart:ffi';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yoga_guru/personal_details.dart';
import 'package:yoga_guru/util/CommonMethods.dart';
import 'package:yoga_guru/util/SessionManager.dart';
import 'package:yoga_guru/util/firebase.dart';
import 'package:yoga_guru/util/loader.dart';
// import 'package:yoga_guru/util/auth.dart';

import 'home.dart';

class Register extends StatefulWidget {
  final List<CameraDescription> cameras;

  const Register({this.cameras});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController _firstNameInputController;
  TextEditingController _lastNameInputController;
  TextEditingController _emailInputController;
  TextEditingController _pwdInputController;
  TextEditingController _confirmPwdInputController;

  // final _auth = FirebaseFirestore.instance.collection('data/registration').snapshots();
  final _auth = FirebaseAuth.instance;

  var _isLoading = false;

  @override
  initState() {
    _firstNameInputController = TextEditingController();
    _lastNameInputController = TextEditingController();
    _emailInputController = TextEditingController();
    _pwdInputController = TextEditingController();
    _confirmPwdInputController = TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);

    if (value.length == 0) {
      return 'Email cannot be empty';
    } else if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length == 0) {
      return 'Password cannot be empty';
    } else if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else if (_pwdInputController.text != _confirmPwdInputController.text) {
      return 'Password does not match!';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text('Register'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            _isLoading ? Loader() : Container(),
            Container(
              margin: const EdgeInsets.all(32.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _registerFormKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      // First Name Input
                      TextFormField(
                        controller: _firstNameInputController,
                        decoration: InputDecoration(
                          labelText: "First Name",
                          hintText: "John",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(30.0), // #7449D1
                          ),
                        ),
                        validator: (val) {
                          if (val.length < 3) {
                            return "Please Enter a valid first name!";
                          } else {
                            return null;
                          }
                        },
                      ),

                      SizedBox(
                        height: 32.0,
                      ),

                      // Last Name Input
                      TextFormField(
                        controller: _lastNameInputController,
                        decoration: InputDecoration(
                          labelText: "Last Name",
                          hintText: "Doe",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(30.0), // #7449D1
                          ),
                        ),
                        validator: (val) {
                          if (val.length < 3) {
                            return "Please Enter a valid last name!";
                          } else {
                            return null;
                          }
                        },
                      ),

                      SizedBox(
                        height: 32.0,
                      ),

                      // Email Input
                      TextFormField(
                        controller: _emailInputController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "john.doe@gmail.com",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(30.0), // #7449D1
                          ),
                        ),
                        validator: emailValidator,
                      ),

                      SizedBox(
                        height: 32.0,
                      ),

                      // Password Input
                      TextFormField(
                        controller: _pwdInputController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "********",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(30.0), // #7449D1
                          ),
                        ),
                        validator: pwdValidator,
                      ),

                      SizedBox(
                        height: 32.0,
                      ),

                      // Confirm Password Input
                      TextFormField(
                        controller: _confirmPwdInputController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          hintText: "********",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(30.0), // #7449D1
                          ),
                        ),
                        validator: pwdValidator,
                      ),

                      SizedBox(
                        height: 32.0,
                      ),

                      // Button
                      Center(
                        child: ButtonTheme(
                          minWidth: 150.0,
                          child: FlatButton(
                            onPressed: _register,
                            color: Colors.deepPurpleAccent,
                            textColor: Colors.white,
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              'Register',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 32.0,
                      ),

                      // Sign in here
                      Center(
                        child: FlatButton(
                          color: Colors.transparent,
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Already have an account?\nSign in here',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  void _register() async {
    if (_registerFormKey.currentState.validate()) {
      if (_pwdInputController.text == _confirmPwdInputController.text) {
        this.setState(() {
          _isLoading = true;
        });
        try {
          UserCredential user =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  // final user = await _auth.createUserWithEmailAndPassword(
                  email: _emailInputController.text,
                  password: _pwdInputController.text);
          User updateUser = _auth.currentUser;
          String name = _firstNameInputController.text +
              " " +
              _lastNameInputController.text;

          print('name : $name');
          userSetup(name, _emailInputController.text, _pwdInputController.text,
              'email', Platform.isAndroid ? 'android' : 'ios','');
          updateUser.updateProfile(displayName: name);
          // email: _emailInputController.text,

          if (user != null) {
            storeDataInPreferences(updateUser, 'email');
          }
        } on FirebaseAuthException catch (e) {
          this.setState(() {
            _isLoading = false;
          });
          if (e.code == 'weak-password') {
            print('The password provider is too weak');
          } else if (e.code == 'email-already-in-use') {
            print('The account already exist for the email');
          }
          print('FirebaseAuthException : $e');
          CommonMethods.showError(_scaffoldKey, '${e.message}');
        } catch (err) {
          this.setState(() {
            _isLoading = false;
          });
          print('err : ' + err.toString());
        }
      }

    }
  }
  void storeDataInPreferences(User userDetails, String userType) {
    /*SessionManager.setUserData(
          SessionManager.USER_DETAIL, json.encode(userDetails));*/
    SessionManager.setStringData(SessionManager.USER_ID, userDetails.uid);
    SessionManager.setStringData(
        SessionManager.FIRST_NAME, _firstNameInputController.text);
    SessionManager.setStringData(
        SessionManager.LAST_NAME, _lastNameInputController.text);
    // String fullName = userDetails.displayName;
    String fullName =
        _firstNameInputController.text + ' ' + _lastNameInputController.text;
    print('userDetails : ${userDetails}');
    SessionManager.setStringData(SessionManager.FULL_NAME, fullName);
    SessionManager.setStringData(SessionManager.EMAIL, userDetails.email);
    SessionManager.setStringData(SessionManager.PHOTO, userDetails.photoURL);
    SessionManager.setStringData(SessionManager.USER_TYPE, userType);
    goToNext();
  }

  void goToNext() {
    this.setState(() {
      _isLoading = false;
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalDetails(
        // builder: (context) => Home(
          // email: updateUser.email,
          // uid: updateUser.uid,
          // displayName: updateUser.displayName,
          // photoUrl: updateUser.photoURL,
          cameras: widget.cameras,
        ),
      ),
      ModalRoute.withName('/login'),
    );
  }
}
