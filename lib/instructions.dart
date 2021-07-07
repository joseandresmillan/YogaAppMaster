import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yoga_guru/inference.dart';
import 'package:yoga_guru/poses.dart';
import 'package:yoga_guru/scale_route.dart';
import 'package:yoga_guru/util/pose_data.dart';
import 'package:yoga_guru/yoga_card.dart';

class Instructions extends StatelessWidget {
  final List<CameraDescription> cameras;
  final String title;
  final String model;
  final String asanas;
  // final List<String> asanas;
  final Color color;

  const Instructions(
      {this.cameras, this.title, this.model, this.asanas, this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text('Instrucciones'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
              child : Container(
                alignment: Alignment.center,
                // height: 200,
                // width: 200,
                child: Image.asset(
                  "assets/images/guideline_image.png",
                  fit: BoxFit.cover,
                ),
              )),
              Container(
                margin: EdgeInsets.all(16.0),
                child: Text(
                  'Por favor situa tu telefono a una distancia donde tu cuerpo sea visible para la camara',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: ButtonTheme(
                  minWidth: 200,
                  height: 60,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: FlatButton(
                    color: color,
                    child: Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => _onSelect(
                      context,asanas,
                    ),
                  ),
                ),
              ),
            ]));
  }

  void _onSelect(BuildContext context, String customModelName) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => InferencePage(
          cameras: cameras,
          title: customModelName,
          model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
          customModel: customModelName,
        ),
      ),
    );
  }

}
