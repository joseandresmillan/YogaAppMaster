import 'dart:ffi';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yoga_guru/util/CommonMethods.dart';
import 'package:yoga_guru/util/SessionManager.dart';
import 'package:yoga_guru/util/firebase.dart';
import 'package:yoga_guru/util/loader.dart';
// import 'package:yoga_guru/util/auth.dart';

import 'home.dart';

class PersonalDetails extends StatefulWidget {
  final List<CameraDescription> cameras;

  const PersonalDetails({this.cameras});

  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _updateFormKey = GlobalKey<FormState>();
  TextEditingController _weightInputController;
  TextEditingController _heightInputController;

  // final _auth = FirebaseFirestore.instance.collection('data/registration').snapshots();
  final _auth = FirebaseAuth.instance;

  String userId = '',
      firstName = '',
      lastName = '',
      fullName = '',
      email = '',
      photo = '',
      _gender = '',
      _ageGroup = '',
      height = '',
      weight = '';
  String photoUrl;
  var _isLoading = false;

  var gender = [
    'Select Gender',
    'Male',
    'Female',
    'Other',
    'Prefer not to say'
  ];
  var ageGroup = [
    'Select Age Group',
    '06-13 Years',
    '14-17 Years',
    '18-24 Years',
    '25-34 Years',
    '35-50 Years',
    '50+ Years'
  ];
  String currentGenderSelected;
  String currentAgeSelected;

  @override
  initState() {
    _weightInputController = TextEditingController();
    _heightInputController = TextEditingController();

    currentGenderSelected = 'Select Gender';
    currentAgeSelected = 'Select Age Group';

    getUserDetails();
    super.initState();
  }

  void getUserDetails() async {
    userId = await SessionManager.getStringData(SessionManager.USER_ID);
    firstName = await SessionManager.getStringData(SessionManager.FIRST_NAME);
    lastName = await SessionManager.getStringData(SessionManager.LAST_NAME);
    fullName = await SessionManager.getStringData(SessionManager.FULL_NAME);
    email = await SessionManager.getStringData(SessionManager.EMAIL);
    photo = await SessionManager.getStringData(SessionManager.PHOTO);
    _gender = await SessionManager.getStringData(SessionManager.GENDER);
    _ageGroup = await SessionManager.getStringData(SessionManager.AGE_GROUP);
    height = await SessionManager.getStringData(SessionManager.HEIGHT);
    weight = await SessionManager.getStringData(SessionManager.WEIGHT);

    print('userID : $userId');
    print('firstName : $firstName');
    print('lastName : $lastName');
    print('fullName : $fullName');
    print('email : $email');
    print('photo : $photo');
    print('_gender : $_gender');
    print('_ageGroup : $_ageGroup');
    print('height : $height');
    print('weight : $weight');

    if (_gender.isNotEmpty) {
      currentGenderSelected = _gender;
    }
    if (_ageGroup.isNotEmpty) {
      currentAgeSelected = _ageGroup;
    }
    if (height.isNotEmpty) {
      _heightInputController.text = height;
    }
    if (weight.isNotEmpty) {
      _weightInputController.text = weight;
    }

    User currentUser = auth.currentUser;
    print('currentUser : ${currentUser}');
    // currentUser.displayName;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text('Personal Details'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            _isLoading ? Loader() : Container(),
            Container(
              margin: const EdgeInsets.all(32.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _updateFormKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          height: 55,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // color: Colors.white
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),
                              border: Border.all(width: 1, color: Colors.grey)),
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Container(
                              margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                              /*  Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Select Gender",
                                      style: TextStyle(
                                          color: const Color(0xff555555),
                                          // fontWeight: FontWeight.w900,
                                          fontSize: 12))),
                           */ child: Row(children: <Widget>[
                            Expanded(
                              // Align(
                              //     alignment: Alignment.centerLeft,
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  underline: Container(
                                      color: Colors.transparent),
                                  items:
                                  gender.map((String dropDownStringItem) {
                                    return DropdownMenuItem<String>(
                                      value: dropDownStringItem,
                                      child: Text(dropDownStringItem),
                                    );
                                  }).toList(),
                                  onChanged: (String newDropDownValue) {
                                    this.setState(() {
                                      this.currentGenderSelected =
                                          newDropDownValue;
                                      print("currentGenderSelected : $currentGenderSelected");
                                      return true;
                                    });
                                  },
                                  value: currentGenderSelected,
                                ))
                          ])
                          )),

                      SizedBox(
                        height: 32.0,
                      ),

                      // Age Group
                      Container(
                          height: 55,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(35.0)),
                              border: Border.all(width: 1, color: Colors.grey)),
                          // margin: EdgeInsets.fromLTRB(0, 20, 0, 32),
                          child: Container(
                              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                              /*Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Select Age Group",
                                      style: TextStyle(
                                          color: const Color(0xff555555),
                                          // fontWeight: FontWeight.w900,
                                          fontSize: 14.0))),
                            */ child: Row(children: <Widget>[
                            Expanded(
                              // Align(
                              //     alignment: Alignment.centerLeft,
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  underline: Container(
                                      color: Colors.transparent),
                                  items:
                                  ageGroup.map((String dropDownStringItem) {
                                    return DropdownMenuItem<String>(
                                      value: dropDownStringItem,
                                      child: Text(dropDownStringItem),
                                    );
                                  }).toList(),
                                  onChanged: (String newDropDownValue) {
                                    this.setState(() {
                                      this.currentAgeSelected =
                                          newDropDownValue;
                                      print(
                                          "currentAgeSelected : $currentAgeSelected");
                                      return true;
                                    });
                                  },
                                  value: currentAgeSelected,
                                ))
                          ])
                          )),

                      SizedBox(
                        height: 32.0,
                      ),

                      // Weight Input
                      TextFormField(
                        controller: _weightInputController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Enter Weight (Kg)",
                          hintText: "50",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(30.0), // #7449D1
                          ),
                        ),
                        validator: (val) {
                          if (val.length < 2) {
                            return "Please Enter Your Weight!";
                          } else {
                            return null;
                          }
                        },
                      ),

                      SizedBox(
                        height: 32.0,
                      ),

                      // Height Input
                      TextFormField(
                        controller: _heightInputController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Height (ft)",
                          hintText: "5.5",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(30.0), // #7449D1
                          ),
                        ),
                        validator: (val) {
                          if (val.length < 1) {
                            return "Please Enter Your Height!";
                          } else {
                            return null;
                          }
                        },
                      ),

                      SizedBox(
                        height: 32.0,
                      ),

                      // Button
                      Center(
                        child: ButtonTheme(
                          minWidth: 150.0,
                          child: FlatButton(
                            onPressed: () {
                              if (currentGenderSelected == '' ||
                                  currentGenderSelected == "Select Gender") {
                                CommonMethods.showError(
                                    _scaffoldKey, 'Please Select Your Gender');
                              } else if (currentAgeSelected == '' ||
                                  currentAgeSelected == "Select Age Group") {
                                CommonMethods.showError(_scaffoldKey,
                                    'Please Select Your Age Group');
                              } else {
                                _update();
                              }
                            },
                            color: Colors.deepPurpleAccent,
                            textColor: Colors.white,
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              'Submit',
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  void _update() async {
    if (_updateFormKey.currentState.validate()) {
      this.setState(() {
        _isLoading = true;
      });
      try {
        User updateUser = _auth.currentUser;
        String name =
            _weightInputController.text + " " + _heightInputController.text;

        print('name : $name');
        updateUserDetails(
            uid: updateUser.uid,
            gender: currentGenderSelected,
            weight: _weightInputController.text,
            height: _heightInputController.text,
            age_group: currentAgeSelected);
        // updateUser.updateProfile(displayName: name);
        // email: _emailInputController.text,

        if (updateUser != null) {
          storeDataInPreferences(
              updateUser,
              currentGenderSelected,
              currentAgeSelected,
              _weightInputController.text,
              _heightInputController.text);
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

    void storeDataInPreferences(User userDetails, String userGender,
        String userAge, String userWeight, String userHeight) {
      SessionManager.setStringData(SessionManager.USER_ID, userDetails.uid);
      SessionManager.setStringData(SessionManager.WEIGHT, userWeight);
      SessionManager.setStringData(SessionManager.HEIGHT, userHeight);
      SessionManager.setStringData(SessionManager.GENDER, userGender);
      SessionManager.setStringData(SessionManager.AGE_GROUP, userAge);
      goToNext();
    }

    void goToNext() {
      this.setState(() {
        _isLoading = false;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Home(
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
