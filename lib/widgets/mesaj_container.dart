import 'package:flutter/material.dart';

Container mesajContainer(double height,Color color,Widget widget ){
  return Container(
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(Radius.circular(10))
    ),
    child: widget,
  );
}