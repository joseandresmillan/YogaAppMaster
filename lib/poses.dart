import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yoga_guru/inference.dart';
import 'package:yoga_guru/instructions.dart';
import 'package:yoga_guru/scale_route.dart';
import 'package:yoga_guru/yoga_card.dart';

class Poses extends StatelessWidget {
  final List<CameraDescription> cameras;
  final String title;
  final String model;
  final List<String> asanas;
  final Color color;

  const Poses({this.cameras, this.title, this.model, this.asanas, this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(title),
      ),
      body: Center(
        child: Container(
          height: 500,
          child: Swiper(
            itemCount: asanas.length,
            loop: false,
            viewportFraction: 0.8,
            scale: 0.82,
            outer: true,
            pagination: SwiperPagination(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(32.0),
            ),
            onTap: (index) => _onPoseSelect(context,title, asanas[index], color),
            // onTap: (index) => _onSelect(context, asanas[index]),
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Container(
                  height: 380,
                  child: YogaCard(
                    asana: asanas[index],
                    color: color,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }



  void _onPoseSelect(
      BuildContext context,
      String title,
      String asanas,
      // List<String> asanas,
      Color color,
      ) async {
    Navigator.push(
      context,
      ScaleRoute(
        page: Instructions(
          cameras: this.cameras,
          title: title,
          model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
          asanas: asanas,
          color: color,
        ),
      ),
    );
  }

  void _onSelect(BuildContext context, String customModelName) async {
    Navigator.push(
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
