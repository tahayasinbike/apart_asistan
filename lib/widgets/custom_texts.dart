
import 'package:apart_asistan/utils/customTextStyle.dart';
import 'package:flutter/material.dart';

Text titleText(String text) {
    return Text(
      text,
      style: CustomTextStyle.titleTextStyle,
    );
  }
Widget customText(String text, Color color) => Text(
      text,
      style: TextStyle(color: color),
     );