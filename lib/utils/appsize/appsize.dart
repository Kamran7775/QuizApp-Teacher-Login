import 'package:flutter/material.dart';

class AppSize {
  static double calculateHeight(BuildContext context, double height,
      {designHeight = 821}) {
    double phoneHeight = MediaQuery.of(context).size.height;

    return (phoneHeight * height) / designHeight;
  }

  static double calculateWidth(BuildContext context, double width) {
    double phoneWidth = MediaQuery.of(context).size.width;

    return (phoneWidth * width) / 500;
  }
}
