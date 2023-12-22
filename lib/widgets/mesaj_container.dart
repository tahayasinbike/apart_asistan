import 'package:flutter/material.dart';

Container mesajContainer(double height,Color color ){
  return Container(
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(Radius.circular(10))
    ),
  );
}