import 'package:flutter/material.dart';
import '../../state/bloc.dart';

// turning weight images into buttons: I am guessing that I wrap each one in a gesture detector

class Weights {
  final weights = new Map<String, Widget>();

  Weights(double screenWidth, double screenHeight, Bloc bloc) {
    weights['fortyfive'] = GestureDetector(
      onTap: () {
        bloc.addWeight(90);
      },
      child: Image.asset(
        'assets/45btn.jpg',
        width: screenWidth/2.75,
        height: screenHeight/5,
      )
    );
    weights['twentyfive'] = GestureDetector(
      onTap: () {
        bloc.addWeight(50);
      },
      child: Image.asset(
        'assets/25btn.jpg',
        width: screenWidth/4,
        height: screenHeight/8,
      )
    );
    weights['ten'] = GestureDetector(
      onTap: () {
        bloc.addWeight(20);
      },
      child: Image.asset('assets/10btn.jpg',
        width: screenWidth/5,
        height: screenHeight/10,)
    );
    weights['five'] = GestureDetector(
      onTap: () {
        bloc.addWeight(10);
      },
      child: Image.asset('assets/5btn.jpg',
        width: screenWidth/6.5,
        height: screenHeight/12,)
    );
    weights['twoandhalf'] = GestureDetector(
      onTap: () {
        bloc.addWeight(5);
      },
      child: Image.asset('assets/2point5btn.jpg',
        width: screenWidth/7.5,
        height: screenHeight/14,)
    );
  }

  Map<String, Widget> get getWeights => weights;
}