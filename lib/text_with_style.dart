import 'package:flutter/material.dart';

class TextWithStyle extends Text {
  TextWithStyle(
      String data,
      {
        color: Colors.black,
        fontSize: 15.0
      }
      ): super(
      data,
      textAlign: TextAlign.center,
      style: new TextStyle(
          color: color,
          fontSize: fontSize
      )
  );
}