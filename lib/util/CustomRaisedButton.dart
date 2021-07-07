import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;

  //final double height;
  final Function onPressed;

  const CustomRaisedButton({
    Key key,
    @required this.child,
    this.gradient,
    this.width = double.infinity,
    //this.height = 50.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 46.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(23.0)),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              offset: Offset(0.0, 1.5),
              blurRadius: 1.5,
            ),
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(23.0)),
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
