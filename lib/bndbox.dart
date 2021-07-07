import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:yoga_guru/util/CustomRaisedButton.dart';
import 'package:yoga_guru/util/SessionManager.dart';
import 'package:yoga_guru/util/firebase.dart';

List<dynamic> _inputArr = [];
String _label = 'Wrong Pose';
double _percent = 0;
double _counter = 0;

class Vector {
  double x, y;

  Vector(this.x, this.y);
}

class MyPainter extends CustomPainter {
  Vector left;
  Vector right;

  MyPainter({this.left, this.right});

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(left.x, left.y);
    final p2 = Offset(right.x, right.y);
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class BndBox extends StatefulWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final String customModel;

  const BndBox({
    this.results,
    this.previewH,
    this.previewW,
    this.screenH,
    this.screenW,
    this.customModel,
  });

  @override
  _BndBoxState createState() => _BndBoxState();
}

class _BndBoxState extends State<BndBox> {
  static const platform = const MethodChannel('ondeviceML');

  var leftEarPos = Vector(0, 0);
  var rightEarPos = Vector(0, 0);
  var nosePos = Vector(0, 0);
  var leftEyePos = Vector(0, 0);
  var rightEyePos = Vector(0, 0);
  var leftShoulderPos = Vector(0, 0);
  var rightShoulderPos = Vector(0, 0);
  var leftHipPos = Vector(0, 0);
  var rightHipPos = Vector(0, 0);
  var leftElbowPos = Vector(0, 0);
  var rightElbowPos = Vector(0, 0);
  var leftWristPos = Vector(0, 0);
  var rightWristPos = Vector(0, 0);
  var leftKneePos = Vector(0, 0);
  var rightKneePos = Vector(0, 0);
  var leftAnklePos = Vector(0, 0);
  var rightAnklePos = Vector(0, 0);

  bool isFeedbackPopup = false;
  String userId = '', firstName = '', lastName = '', fullName = '', email = '';

  TextEditingController _nameInputController = TextEditingController();
  TextEditingController _emailInputController = TextEditingController();
  TextEditingController _commentInputController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
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
    void _getKeyPoints(k, x, y) {
      if (k["part"] == 'leftEar') {
        leftEarPos.x = x - 270;
        leftEarPos.y = y - 45;
      }
      if (k["part"] == 'rightEar') {
        rightEarPos.x = x - 270;
        rightEarPos.y = y - 45;
      }
      if (k["part"] == 'nose') {
        nosePos.x = x - 270;
        nosePos.y = y - 45;
      }
      if (k["part"] == 'leftEye') {
        leftEyePos.x = x - 270;
        leftEyePos.y = y - 45;
      }
      if (k["part"] == 'rightEye') {
        rightEyePos.x = x - 270;
        rightEyePos.y = y - 45;
      }
      if (k["part"] == 'leftShoulder') {
        leftShoulderPos.x = x - 270;
        leftShoulderPos.y = y - 45;
      }
      if (k["part"] == 'rightShoulder') {
        rightShoulderPos.x = x - 270;
        rightShoulderPos.y = y - 45;
      }
      if (k["part"] == 'leftElbow') {
        leftElbowPos.x = x - 270;
        leftElbowPos.y = y - 45;
      }
      if (k["part"] == 'rightElbow') {
        rightElbowPos.x = x - 270;
        rightElbowPos.y = y - 45;
      }
      if (k["part"] == 'leftWrist') {
        leftWristPos.x = x - 270;
        leftWristPos.y = y - 45;
      }
      if (k["part"] == 'rightWrist') {
        rightWristPos.x = x - 270;
        rightWristPos.y = y - 45;
      }
      if (k["part"] == 'leftHip') {
        leftHipPos.x = x - 270;
        leftHipPos.y = y - 45;
      }
      if (k["part"] == 'rightHip') {
        rightHipPos.x = x - 270;
        rightHipPos.y = y - 45;
      }
      if (k["part"] == 'leftKnee') {
        leftKneePos.x = x - 270;
        leftKneePos.y = y - 45;
      }
      if (k["part"] == 'rightKnee') {
        rightKneePos.x = x - 270;
        rightKneePos.y = y - 45;
      }
      if (k["part"] == 'leftAnkle') {
        leftAnklePos.x = x - 270;
        leftAnklePos.y = y - 45;
      }
      if (k["part"] == 'rightAnkle') {
        rightAnklePos.x = x - 270;
        rightAnklePos.y = y - 45;
      }
    }

    List<Widget> _renderKeypoints() {
      var lists = <Widget>[];
      widget.results.forEach((re) {
        print("re::: ${re}");
        var list = re["keypoints"].values.map<Widget>((k) {
          var _x = k["x"];
          var _y = k["y"];
          var scaleW, scaleH, x, y;

          if (widget.screenH / widget.screenW >
              widget.previewH / widget.previewW) {
            scaleW = widget.screenH / widget.previewH * widget.previewW;
            scaleH = widget.screenH;
            var difW = (scaleW - widget.screenW) / scaleW;
            x = (_x - difW / 2) * scaleW;
            y = _y * scaleH;
          } else {
            scaleH = widget.screenW / widget.previewW * widget.previewH;
            scaleW = widget.screenW;
            var difH = (scaleH - widget.screenH) / scaleH;
            x = _x * scaleW;
            y = (_y - difH / 2) * scaleH;
          }
          // print('x: ' + x.toString());
          // print('y: ' + y.toString());

          _inputArr.add(x);
          _inputArr.add(y);

          // To solve mirror problem on front camera
          if (x > 320) {
            var temp = x - 320;
            x = 320 - temp;
          } else {
            var temp = 320 - x;
            x = 320 + temp;
          }

          if (k["part"] == 'leftEye') {
            leftEyePos.x = x - 230;
            leftEyePos.y = y - 45;
          }
          if (k["part"] == 'rightEye') {
            rightEyePos.x = x - 230;
            rightEyePos.y = y - 45;
          }

          _getKeyPoints(k, x, y);

          return Positioned(
            left: x - 275,
            top: y - 50,
            width: 100,
            height: 15,
            child: Container(
              child: Text(
                "● ${k["part"]}",
                style: TextStyle(
                  color: Color.fromRGBO(37, 213, 253, 1.0),
                  fontSize: 12.0,
                ),
              ),
            ),
          );
        }).toList();

        // print("Input Arr: " + _inputArr.toList().toString());
        _getPrediction(_inputArr.cast<double>().toList());

        _inputArr.clear();
        // print("Input Arr after clear: " + _inputArr.toList().toString());

        lists..addAll(list);
      });
      return lists;
    }

    return Stack(children: <Widget>[
      Stack(
        children: [
          CustomPaint(
            painter: MyPainter(left: leftEarPos, right: leftEyePos),
          ),
          CustomPaint(
            painter: MyPainter(left: leftEyePos, right: nosePos),
          ),
          CustomPaint(
            painter: MyPainter(left: nosePos, right: rightEyePos),
          ),
          CustomPaint(
            painter: MyPainter(left: rightEyePos, right: rightEarPos),
          ),
          CustomPaint(
            painter: MyPainter(left: leftShoulderPos, right: rightShoulderPos),
          ),
          CustomPaint(
            painter: MyPainter(left: leftElbowPos, right: leftShoulderPos),
          ),
          CustomPaint(
            painter: MyPainter(left: leftWristPos, right: leftElbowPos),
          ),
          CustomPaint(
            painter: MyPainter(left: rightElbowPos, right: rightShoulderPos),
          ),
          CustomPaint(
            painter: MyPainter(left: rightWristPos, right: rightElbowPos),
          ),
          CustomPaint(
            painter: MyPainter(left: leftShoulderPos, right: leftHipPos),
          ),
          CustomPaint(
            painter: MyPainter(left: leftHipPos, right: leftKneePos),
          ),
          CustomPaint(
            painter: MyPainter(left: leftKneePos, right: leftAnklePos),
          ),
          CustomPaint(
            painter: MyPainter(left: rightShoulderPos, right: rightHipPos),
          ),
          CustomPaint(
            painter: MyPainter(left: rightHipPos, right: rightKneePos),
          ),
          CustomPaint(
            painter: MyPainter(left: rightKneePos, right: rightAnklePos),
          ),
          CustomPaint(
            painter: MyPainter(left: leftHipPos, right: rightHipPos),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 16.0),
            child: Text(
              _label.toString(),
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 25.0),
            child: LinearPercentIndicator(
              animation: true,
              lineHeight: 20.0,
              animationDuration: 500,
              animateFromLastPercent: true,
              percent: _counter,
              center: Text("${(_counter * 100).toStringAsFixed(1)} %"),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.green,
            ),
          ),
        ],
      ),
      Stack(
        children: _renderKeypoints(),
      ),
    ]);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(50, 50);
    final p2 = Offset(250, 150);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;
    canvas.drawLine(p1, p2, paint);
  }

  Future<void> _getPrediction(List<double> poses) async {
    try {
      final double result = await platform.invokeMethod('predictData', {
        "model": widget.customModel,
        "arg": poses,
      }); // passing arguments

      print('result : $result');
      _percent = result;
      _label =
          result < 0.5 ? "Wrong Pose" : (result * 100).toStringAsFixed(0) + "%";
      updateCounter(_percent);

      print("Final Label: " + result.toString());
    } on PlatformException catch (e) {
      return e.message;
    }
  }

  void updateCounter(perc) {
    // print('_percent : $perc');

    if (perc > 0.5) {
      (_counter += perc / 100) >= 1 ? _counter = 1.0 : _counter += perc / 100;
    }
    print("Counter: " + _counter.toString());

    if (_counter >= 1.0) {
      if (!isFeedbackPopup) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return showInterestedAlertDialog(context);
            });
      }
    }
  }

  showInterestedAlertDialog(BuildContext context) {
    isFeedbackPopup = true;
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
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pop(context);
                        },
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
                                setState(() {
                                  _isLoading = true;
                                  feedbackSetup(
                                      userId,
                                      _nameInputController.text
                                          .toString()
                                          .trim(),
                                      _emailInputController.text
                                          .toString()
                                          .trim(),
                                      _commentInputController.text
                                          .toString()
                                          .trim(),
                                      Platform.isAndroid ? 'android' : 'ios');
                                });
                                Navigator.of(context).pop();
                                Navigator.pop(context);
                              })),
                    ],
                  ),
                ],
              )),
        ));
  }
}
