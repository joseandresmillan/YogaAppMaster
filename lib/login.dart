import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yoga_guru/home.dart';
import 'package:yoga_guru/personal_details.dart';
import 'package:yoga_guru/register.dart';
import 'package:yoga_guru/util/CommonMethods.dart';
import 'package:yoga_guru/util/SessionManager.dart';
import 'package:yoga_guru/util/firebase.dart';
import 'package:yoga_guru/util/loader.dart';
// import 'package:yoga_guru/util/auth.dart';

class Login extends StatefulWidget {
  final List<CameraDescription> cameras;

  const Login({this.cameras});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController _emailInputController = TextEditingController();
  TextEditingController _pwdInputController = TextEditingController();
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  // final DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("User");

  final _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  CollectionReference _collectionRef;

  String gmailPass = 'yoga_1@ai';

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
    } else {
      return null;
    }
  }

  @override
  void initState() {
    _collectionRef = FirebaseFirestore.instance.collection('user');
    print('widget.cameras : ${widget.cameras}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text('Login'),
          centerTitle: true,
          leading: Container(),
        ),
        body: Stack(
          children: [
            _isLoading ? Loader() : Container(),
            SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 32.0),
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      children: <Widget>[
                        // Image
                        Container(
                          height: 300,
                          width: 300,
                          padding: const EdgeInsets.only(top: 32.0),
                          child: Image(
                            image: AssetImage('assets/images/yoga1.png'),
                          ),
                        ),

                        // Email
                        TextFormField(
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
                        ),

                        SizedBox(
                          height: 32.0,
                        ),

                        // Password
                        TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          controller: _pwdInputController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
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
                              onPressed: () => _login(
                                  _emailInputController.text,
                                  _pwdInputController.text,
                                  'email'),
                              color: Colors.deepPurpleAccent,
                              textColor: Colors.white,
                              padding: EdgeInsets.all(14.0),
                              child: Text(
                                'Login',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 15,
                        ),

                        // Register Now link
                        Center(
                          child: FlatButton(
                            color: Colors.transparent,
                            onPressed: _onRegister,
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 15,
                        ),

                        // Register Now link
                        Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Divider(
                                        height: 1,
                                        color: Colors.deepPurpleAccent)),
                                Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Text(
                                      'OR',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.deepPurpleAccent),
                                    )),
                                Expanded(
                                    child: Divider(
                                        height: 1,
                                        color: Colors.deepPurpleAccent)),
                              ]),
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        // Register Now link
                        Center(
                          child: InkWell(
                            onTap: () {
                              onClickGoogleLogin();
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[500],
                                      offset: Offset(1, 2),
                                      blurRadius: 5,
                                    ),
                                  ]),
                              child: Image.asset(
                                'assets/images/ic_google.png',
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  void _onRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Register(
          cameras: widget.cameras,
        ),
      ),
    );
  }

  void _login(String email, String pass, String userType,
      {String displayName}) async {
    if (userType.contains('gmail')) {
      goToLogin(email, pass, userType, displayName);
    } else {
      if (_loginFormKey.currentState.validate()) {
        goToLogin(email, pass, userType, displayName);
      }
    }
  }

  // Login With Google
  onClickGoogleLogin() async {
    this.setState(() {
      _isLoading = true;
    });
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: gSA.accessToken,
      idToken: gSA.idToken,
    );
    UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    User users = authResult.user;
    users.getIdToken().then((token) async {
      googleSignIn.signOut();
      // setState(() async {
      print('F-Name : ${users.displayName.split(" ")[0]}');
      print('L-Name : ${users.displayName.split(" ")[1]}');
      print('Email : ${users.email}');
      print('photoURL : ${users.photoURL}');

      _login(users.email, gmailPass, 'gmail', displayName: users.displayName);
/*
        databaseReference.push().set({
          'userID': '1',
          'userFirstName': '${user.displayName.split(" ")[0]}',
          'userLastName': '${user.displayName.split(" ")[1]}',
          'userEmail': '${user.email}',
          'userProfile': '${user.photoURL}',
          'userPassword': '1234567890',
        });*/

      /*  SessionManager.setStringData(
            'tempFirst', user.displayName.split(" ")[0]);
        SessionManager.setStringData(
            'tempLast', user.displayName.split(" ")[1]);
        SessionManager.setStringData('tempEmail', user.email);*/

      // });
    });
    return users;
  }

  goToLogin(
      String email, String pass, String userType, String displayName) async {
    this.setState(() {
      _isLoading = true;
    });
    try {
      UserCredential user =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      // getData();
      if (user != null) {
        var _user = FirebaseAuth.instance.currentUser;
        print('user : $user');
        print('_user : $_user');
        // FirebaseFirestore.instance.collection("users").doc(_user.uid).get().then((querySnapshot){

        FirebaseFirestore.instance
            .collection("users")
            .doc(_user.uid)
            .get()
            .then((querySnapshot) {
          print('querySnapshot : ${querySnapshot.data()}');
          storeDataInPreferences(querySnapshot, userType, _user);
        });
        // storeDataInPreferences(user.user, userType);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provider is too weak');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exist for the email');
      }
      if (userType == 'gmail') {
        try {
          /* UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          // final user = await _auth.createUserWithEmailAndPassword(
            email: users.email,
            password: '1234567890');*/
          User updateUser = FirebaseAuth.instance.currentUser;
          String name = displayName;
          updateUser.updateProfile(displayName: name);

          if (updateUser.uid != null) {
            print('Existing User - Update');
            FirebaseFirestore.instance
                .collection("users")
                .doc(updateUser.uid)
                .get()
                .then((querySnapshot) {
              print('querySnapshot : ${querySnapshot.data()}');
              if (querySnapshot.data() != null &&
                  querySnapshot.data()["displayName"] != '') {
                storeDataInPreferences(querySnapshot, userType, updateUser);
              } else {
                print('come from else - new User - registration');
                userSetup(
                    name,
                    email,
                    gmailPass,
                    userType,
                    Platform.isAndroid ? 'android' : 'ios',
                    updateUser.photoURL);
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(updateUser.uid)
                    .get()
                    .then((querySnapshot) {
                  print('querySnapshot : ${querySnapshot.data()}');
                  storeDataInPreferences(querySnapshot, userType, updateUser);
                });
              }
            });
          } else {
            print('new User - registration');
            userSetup(name, email, gmailPass, userType,
                Platform.isAndroid ? 'android' : 'ios', updateUser.photoURL);
            FirebaseFirestore.instance
                .collection("users")
                .doc(updateUser.uid)
                .get()
                .then((querySnapshot) {
              print('querySnapshot : ${querySnapshot.data()}');

              storeDataInPreferences(querySnapshot, userType, updateUser);
            });
          }
          // });
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
      this.setState(() {
        _isLoading = false;
      });
      print('FirebaseAuthException : $e');
      CommonMethods.showError(_scaffoldKey, '${e.message}');
    } catch (err) {
      this.setState(() {
        _isLoading = false;
      });
      print('err : ' + err.toString());
    }
  }

  void storeDataInPreferences(
      DocumentSnapshot querySnapshot, String userType, User user) {
    /*SessionManager.setUserData(
          SessionManager.USER_DETAIL, json.encode(userDetails));*/
    SessionManager.setStringData(
        SessionManager.USER_ID, querySnapshot.data()["uid"]);
    if (querySnapshot.data()["displayName"] != null) {
      SessionManager.setStringData(SessionManager.FIRST_NAME,
          querySnapshot.data()["displayName"].split(" ")[0]);
      SessionManager.setStringData(SessionManager.LAST_NAME,
          querySnapshot.data()["displayName"].split(" ")[1]);
      String fullName = querySnapshot.data()["displayName"];
      SessionManager.setStringData(SessionManager.FULL_NAME, fullName);
    }
    SessionManager.setStringData(
        SessionManager.EMAIL, querySnapshot.data()["email"]);
    if (userType == 'gmail') {
      SessionManager.setStringData(SessionManager.PHOTO, user.photoURL);
    } else {
      if (querySnapshot.data()["photo"] != '') {
        SessionManager.setStringData(
            SessionManager.PHOTO, querySnapshot.data()["photo"]);
      }
    }
    SessionManager.setStringData(
        SessionManager.USER_TYPE, querySnapshot.data()["userType"]);

    if (querySnapshot.data()["gender"] != '' ||
        querySnapshot.data()["age_group"] != '' ||
        querySnapshot.data()["weight"] != '' ||
        querySnapshot.data()["height"] != '') {
      SessionManager.setStringData(
          SessionManager.AGE_GROUP, querySnapshot.data()["age_group"]);
      SessionManager.setStringData(
          SessionManager.GENDER, querySnapshot.data()["gender"]);
      SessionManager.setStringData(
          SessionManager.WEIGHT, querySnapshot.data()["weight"]);
      SessionManager.setStringData(
          SessionManager.HEIGHT, querySnapshot.data()["height"]);

      goToHome();
    } else {
      goToPersonalDetails();
    }
  }

  void goToPersonalDetails() {
    this.setState(() {
      _isLoading = false;
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalDetails(
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

  void goToHome() {
    this.setState(() {
      _isLoading = false;
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Home(
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

  Future getData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      print('a.id ${a.id}');
    }
  }

/*
  Future<void> getData() async {
    // Get docs from collection reference
    // QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    // final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    // final allData = querySnapshot.docs.map((doc) => doc.data());

 */ /*   QuerySnapshot querySnapshot = await _collectionRef.get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      print('reference : ${a.reference}');
    }
*/ /*
    // FirebaseFirestore.instance.collection("user").get().then(
    _collectionRef.get().then(
          (value) {
        value.docs.forEach(
              (element) {
            print('element.data() : ${element.data()}');
          },
        );
      },
    );

    // print('allData $allData');
  }*/
}
