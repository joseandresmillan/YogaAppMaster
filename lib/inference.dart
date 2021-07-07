import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:yoga_guru/bndbox.dart';
import 'package:yoga_guru/camera.dart';
import 'package:yoga_guru/util/CustomRaisedButton.dart';
import 'package:yoga_guru/util/SessionManager.dart';
import 'package:yoga_guru/util/firebase.dart';

class InferencePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String title;
  final String model;
  final String customModel;

  const InferencePage({this.cameras, this.title, this.model, this.customModel});

  @override
  _InferencePageState createState() => _InferencePageState();
}

class _InferencePageState extends State<InferencePage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String userId = '', firstName = '', lastName = '', fullName = '', email = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController _nameInputController = TextEditingController();
  TextEditingController _emailInputController = TextEditingController();
  TextEditingController _commentInputController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    var res = loadModel();
    print('Model Response: ' + res.toString());
    getUserDetails();
    super.initState();
  }

  void getUserDetails() async {
    userId = await SessionManager.getStringData(SessionManager.USER_ID);
    firstName = await SessionManager.getStringData(SessionManager.FIRST_NAME);
    lastName = await SessionManager.getStringData(SessionManager.LAST_NAME);
    fullName = await SessionManager.getStringData(SessionManager.FULL_NAME);
    email = await SessionManager.getStringData(SessionManager.EMAIL);

    print('userID : $userId');
    print('firstName : $firstName');
    print('lastName : $lastName');
    print('fullName : $fullName');
    print('email : $email');

    _nameInputController.text = firstName + ' ' + lastName;
    _emailInputController.text = email;

    setState(() {});
  }

  final _auth = FirebaseAuth.instance;

  String nameValidator(String value) {
    if (value.length == 0) {
      return 'Name cannot be empty';
    } else {
      return null;
    }
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

  String commentValidator(String value) {
    if (value.length == 0) {
      return 'Comment cannot be empty';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(widget.title),
       /* actions: [
          IconButton(
              icon: Icon(Icons.feedback_outlined),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return showInterestedAlertDialog(context);
                      // return CustomDialog();
                    });
                // displayModalBottomSheet(context),
              })
        ],*/
      ),
      body: Stack(
        children: <Widget>[
          Camera(
            cameras: widget.cameras,
            setRecognitions: _setRecognitions,
          ),
          BndBox(
            results: _recognitions == null ? [] : _recognitions,
            previewH: max(_imageHeight, _imageWidth),
            previewW: min(_imageHeight, _imageWidth),
            screenH: screen.height,
            screenW: screen.width,
            customModel: widget.customModel,
          ),
        ],
      ),
    );
  }

  _setRecognitions(recognitions, imageHeight, imageWidth) {
    if (!mounted) {
      return;
    }
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  loadModel() async {
    return await Tflite.loadModel(
      model: widget.model,
    );
  }

  showInterestedAlertDialog(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        insetPadding: EdgeInsets.all(20),
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Title
                  Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text('Feedback',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold))),

                  // Full Name
                  Container(
                      height: 50,
                      child: TextFormField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _nameInputController,
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(30.0), // #7449D1
                          ),
                        ),
                        validator: emailValidator,
                      )),

                  SizedBox(
                    height: 20.0,
                  ),
                  // Email
                  Container(
                      height: 50,
                      child: TextFormField(
                        enabled: false,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailInputController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(30.0), // #7449D1
                          ),
                        ),
                        validator: emailValidator,
                      )),

                  SizedBox(
                    height: 20.0,
                  ),
                  // Comment
                  Container(
                      child: TextFormField(
                    maxLines: 3,
                    minLines: 3,
                    keyboardType: TextInputType.text,
                    controller: _commentInputController,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: "Comment",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // #7449D1
                      ),
                    ),
                    validator: commentValidator,
                  )),

                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: CustomRaisedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Skip',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        gradient: LinearGradient(
                            colors: [Colors.black12, Colors.black12]),
                      )),
                      SizedBox(width: 20),
                      Expanded(
                          child: CustomRaisedButton(
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              gradient: LinearGradient(colors: [
                                Colors.deepPurpleAccent,
                                Colors.deepPurpleAccent
                              ]),
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _isLoading = true;
                                  feedbackSetup(userId,
                                      _nameInputController.text.toString().trim(),
                                      _emailInputController.text.toString().trim(),
                                      _commentInputController.text.toString().trim(),
                                      Platform.isAndroid ? 'android' : 'ios');
                                });
                              })),
                    ],
                  ),
                ],
              )),
        ));
  }

}
