import 'package:flutter/material.dart';

class ColorHelper {
  final Color black = Colors.black;
  final Color darkGrey = const Color(0xFF676767);
  final Color lightGrey = const Color(0xFFCBCBCB);
  final Color white = Colors.white;
  final Color darkBrown = const Color(0xFF634200);
  final Color lightBrown = const Color(0xFFDCB25F);
  final Color darkBlue = const Color(0xFF014FE0);
  final Color lightBlue = const Color(0xFF6CB6FF);
  final Color darkGreen = const Color(0xFF157100);
  final Color lightGreen = const Color(0xFF5BEB3B);
  final Color red = Colors.red;
  final Color orange = Colors.orange;
  final Color yellow = Colors.yellow;
  final Color cyan = Colors.cyan;
  final Color purple = Colors.deepPurpleAccent;
  final Color pink = const Color(0xFFFF00D4);

  late final Map<String, Color> colorMap = {
    'black': black,
    'darkgrey': darkGrey,
    'lightgrey': lightGrey,
    'white': white,
    'darkbrown': darkBrown,
    'lightbrown': lightBrown,
    'darkblue': darkBlue,
    'lightblue': lightBlue,
    'darkgreen': darkGreen,
    'lightgreen': lightGreen,
    'red': red,
    'orange': orange,
    'yellow': yellow,
    'cyan': cyan,
    'purple': purple,
    'pink': pink,
  };

  Color getColorFromString(String colorString) {
    return colorMap[colorString.toLowerCase()] ?? white;
  }

  String getStringFromColor(Color color) {
    return colorMap.entries
        .firstWhere((entry) => entry.value == color,
            orElse: () => MapEntry('white', white))
        .key;
  }
}
