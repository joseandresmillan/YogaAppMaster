import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoga_guru/instructions.dart';
import 'package:yoga_guru/login.dart';
import 'package:yoga_guru/poses.dart';
import 'package:yoga_guru/profile.dart';
import 'package:yoga_guru/scale_route.dart';
import 'package:yoga_guru/util/CommonMethods.dart';
import 'package:yoga_guru/util/SessionManager.dart';
import 'package:yoga_guru/util/pose_data.dart';

class Home extends StatefulWidget {
  final String email;
  final String uid;
  final String displayName;
  final String photoUrl;
  final List<CameraDescription> cameras;

  Home({
    this.email,
    this.uid,
    this.displayName,
    this.photoUrl,
    this.cameras,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
  List<CameraDescription> cameras;

  final auth = FirebaseAuth.instance;

  DateTime currentBackPressTime;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;

  bool _editMode = false;

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

    User currentUser = auth.currentUser;
    print('currentUser : ${currentUser}');
    // currentUser.displayName;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // User user = User();
    return WillPopScope(
        onWillPop: () {
          onWillPop();
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text('Yog.ai',style: TextStyle(fontSize: 35)),
            leading: Container(
              alignment: Alignment.center,
                margin: EdgeInsets.only(left: 6.0),
                height: 30,
                width: 30,
                /*decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(35.0))),
               */
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(
                        email: email,
                        uid: userId,
                        displayName: fullName,
                        photoUrl: photo,
                      ),
                    ),
                  ),
                  child:
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                    child: Container(
                        width: 30.0,
                        height: 30.0,
                        child:   FadeInImage.assetNetwork(
                              imageErrorBuilder: (context, url, error) =>
                              new Icon(Icons.account_circle_sharp),
                              placeholder: 'assets/images/profile_image.png',
                              image: photo != null
                                  ? photo
                                  :  'assets/images/profile_image.png',
                              fit: BoxFit.cover,
                            )),
                  ),
                  /*CircleAvatar(
                      radius: 60,
                      backgroundImage: photo != null
                          ? NetworkImage(photo != null ? photo :  Image.asset('assets/images/profile_image.png'))
                          // : Icon(Icons.account_circle_sharp)
                      : Image.asset('assets/images/profile_image.png'),
                )*/
                )),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async {
                  // Auth auth = Auth();
                  await auth.signOut();
                  await SessionManager.clearSession();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(
                        cameras: widget.cameras,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Welcome Text
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      'Bienvenido\n$firstName ' + lastName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Beginner Button
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: ButtonTheme(
                      minWidth: 200,
                      height: 60,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: FlatButton(
                        color: Colors.green,
                        child: Text(
                          'Principiante',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => _onPoseSelect(
                          context,
                          'Principiante',
                          beginnerAsanas,
                          Colors.green,
                        ),
                      ),
                    ),
                  ),

                  // Intermediate Button
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: ButtonTheme(
                      minWidth: 200,
                      height: 60,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: FlatButton(
                        color: Colors.blue,
                        child: Text(
                          'Intermedio',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => _onPoseSelect(
                          context,
                          'Intermedio',
                          intermediateAsanas,
                          Colors.blue,
                        ),
                      ),
                    ),
                  ),

                  // Advance Button
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: ButtonTheme(
                      minWidth: 200,
                      height: 60,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: FlatButton(
                        color: Colors.deepPurple,
                        child: Text(
                          'Avanzado',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => _onPoseSelect(
                          context,
                          'Avanzado',
                          advanceAsanas,
                          Colors.deepPurple[400],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _onPoseSelect(
    BuildContext context,
    String title,
    List<String> asanas,
    Color color,
  ) async {
    Navigator.push(
      context,
      ScaleRoute(
        page: Poses(
          cameras: widget.cameras,
          title: title,
          model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
          asanas: asanas,
          color: color,
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      CommonMethods.showError(_scaffoldKey, 'Click BACK again for exit');
      return Future.value(false);
    } else {
      SystemNavigator.pop();
    }
    return Future.value(true);
  }
}

class CircleProfileImage extends StatefulWidget {
  final String image;

  const CircleProfileImage({this.image});

  @override
  _CircleProfileImageState createState() => _CircleProfileImageState(image);
}

class _CircleProfileImageState extends State<CircleProfileImage> {
  final String image;

  _CircleProfileImageState(this.image);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'profile',
      child: Center(
        child: CircleAvatar(
            radius: 15,
            backgroundImage: image.isEmpty
                ? AssetImage(
                    'assets/images/profile_image.png',
                  )
                : FadeInImage.assetNetwork(
                    imageErrorBuilder: (context, url, error) =>
                        new Icon(Icons.error),
                    placeholder: 'assets/images/profile_image.png',
                    image: image != null
                        ? image
                        : 'assets/images/profile_image.png',
                    fit: BoxFit.cover,
                  )
            //NetworkImage(image),
            ),
      ),
    );
  }
}
