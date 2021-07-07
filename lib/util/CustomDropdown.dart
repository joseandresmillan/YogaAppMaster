import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

typedef onTapCallBack = void Function(String);

// ignore: must_be_immutable
class CustomDropdown extends StatefulWidget {
  String label;
  String errorText = '';
  List<String> arrValue = [];
  String selectedValue = '';
  final onTapCallBack onTap;

  CustomDropdown(
      {Key key,
      this.label = "",
      this.errorText = '',
      @required this.arrValue,
      @required this.selectedValue,
      this.onTap})
      : super(key: key);

  @override
  _CustomDropdownState createState() {
    return _CustomDropdownState();
  }
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 0, bottom: 4),
          alignment: Alignment.topLeft,
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize : 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          elevation: 0.0,
          color: Colors.transparent,
          // shadowColor: grayColor,
          // margin: EdgeInsets.only(left: 0, right: 0),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                      /* decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        gradient: LinearGradient(
                            colors: [yellowLightColor, orangeLightColor]),
                      ),*/
                      // width: 50.0,
                      // height: 50.0,
                      // margin: EdgeInsets.only(right: 10),
                      alignment: Alignment.bottomRight,
                      // child: Center(
                      child: Transform.rotate(
                        angle: 90 * math.pi / 180,
                        child: Icon(
                          Icons.navigate_next,
                          size: 35.0,
                          color: Colors.black,
                        ),
                      ),
                      // ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 48,
                      padding: EdgeInsets.only(left: 12.0),
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        value: widget.selectedValue,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 0,
                        elevation: 0,
                        style: TextStyle(
                            fontSize : 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        underline: Container(),
                        onChanged: (String data) {
                          setState(() {
                            widget.onTap(data);
                            widget.selectedValue = data;
                            // isValidate();
                          });
                        },
                        items: widget.arrValue
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value.toUpperCase(),
                              maxLines: 1,
                              style: TextStyle(
                                fontSize : 14.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        widget.errorText != ''
            ? Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 4),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.errorText,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 10.0, fontWeight: FontWeight.normal,
                        color: Colors.red),
                  ),
                ),
              )
            : Container(),
      ],
    ));
  }
}
