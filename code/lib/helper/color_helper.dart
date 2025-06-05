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
  final Color blue = Colors.blue;
  final Color green = Colors.green;
  final Color yellow = Colors.yellow;
  final Color orange = Colors.orange;
  final Color purple = Colors.purple;
  final Color pink = Colors.pink;
  final Color brown = Colors.brown;
  final Color teal = Colors.teal;
  final Color navy = const Color(0xFF000080);
  final Color maroon = const Color(0xFF800000);
  final Color olive = const Color(0xFF808000);
  final Color lime = Colors.lime;

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
    'blue': blue,
    'green': green,
    'yellow': yellow,
    'orange': orange,
    'purple': purple,
    'pink': pink,
    'brown': brown,
    'teal': teal,
    'navy': navy,
    'maroon': maroon,
    'olive': olive,
    'lime': lime,
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
