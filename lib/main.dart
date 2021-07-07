import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoga_guru/home.dart';
import 'package:yoga_guru/login.dart';
import 'package:yoga_guru/personal_details.dart';
import 'package:yoga_guru/util/SessionManager.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  try {
    cameras = await availableCameras();
    print('camera : $cameras');
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }

  Widget _defaultWidgets = Login(cameras: cameras);

  String userType =
      await SessionManager.getStringData(SessionManager.USER_TYPE);
  String userId = await SessionManager.getStringData(SessionManager.USER_ID);
  String fullName = await SessionManager.getStringData(SessionManager.FULL_NAME);
  String _gender = await SessionManager.getStringData(SessionManager.GENDER);
  String _ageGroup = await SessionManager.getStringData(SessionManager.AGE_GROUP);
  String height = await SessionManager.getStringData(SessionManager.HEIGHT);
  String weight = await SessionManager.getStringData(SessionManager.WEIGHT);

  if (userId.isNotEmpty) {
    if (_gender.isNotEmpty && _ageGroup.isNotEmpty && height.isNotEmpty && weight.isNotEmpty) {
      _defaultWidgets = Home(cameras: cameras);
    } else {
      _defaultWidgets = PersonalDetails(cameras: cameras);
    }
  }

/*
    SharedPreferences prefs = await SharedPreferences.getInstance();

  String email = prefs.getString('email');
  String uid = prefs.getString('uid');
  String displayName = prefs.getString('displayName');
  String photoUrl = prefs.getString('photoUrl');

  User user = User();
  user.setUser({
    'email': email,
    'displayName': displayName,
    'uid': uid,
    'photoUrl': photoUrl,
  });
*/

  runApp(MyApp(
    defaultWidgets: _defaultWidgets,
  ));

  /*runApp(
    email != null && uid != null
        ? MyApp(
            email: user.email,
            uid: user.uid,
            displayName: user.displayName,
            photoUrl: user.photoUrl,
            cameras: cameras,
          )
        : MyApp(
            cameras: cameras,
          ),
  );*/
}

class MyApp extends StatefulWidget {
  // final String email;
  // final String uid;
  // final String displayName;
  // final String photoUrl;
  final List<CameraDescription> cameras;
  Widget defaultWidgets;

  MyApp(
      {
      // this.email,
      // this.uid,
      // this.displayName,
      // this.photoUrl,
      this.cameras,
      this.defaultWidgets});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Yog.ai',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          child: Scaffold(
            backgroundColor: Colors.black,
            body: widget.defaultWidgets,
          ),
        )
        /*initialRoute: (email != null && uid != null) ? '/' : '/login',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => Home(
              email: email,
              uid: uid,
              displayName: displayName,
              photoUrl: photoUrl,
              cameras: cameras,
            ),
        '/login': (BuildContext context) => Login(
              cameras: cameras,
            ),
        'register': (BuildContext context) => Register(),*/
        // },
        );
  }
}
