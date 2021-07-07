
import 'package:flutter/material.dart';


class CommonMethods {
  static showError(GlobalKey<ScaffoldState> scaffoldKey, String msg,
      {int duration}) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.error,
                color: Colors.white,
                size: 16.0,
              ),
              SizedBox(
                width: 8.0,
              ),
              Flexible(child: Text(msg,
                style: TextStyle(fontSize: 12.0, color: Colors.white),
              )),
            ],
          )),
      duration:
          duration != null ? Duration(seconds: duration) : Duration(seconds: 2),
      backgroundColor: Colors.black87,
    ));
  }
}