import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class for helping to represent the pre defined set of colors 
// for the clothing items
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

  // map of strings to Colors 
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

  // gets and returns Color from pre defined set with given String 
  // white default 
  Color getColorFromString(String colorString, BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) return white;

    // Map localized color names to English keys
    final Map<String, String> localizedToEnglish = {
      loc.black: 'black',
      loc.darkGrey: 'darkgrey',
      loc.lightGrey: 'lightgrey',
      loc.white: 'white',
      loc.darkBrown: 'darkbrown',
      loc.lightBrown: 'lightbrown',
      loc.darkBlue: 'darkblue',
      loc.lightBlue: 'lightblue',
      loc.darkGreen: 'darkgreen',
      loc.lightGreen: 'lightgreen',
      loc.red: 'red',
      loc.blue: 'blue',
      loc.green: 'green',
      loc.yellow: 'yellow',
      loc.orange: 'orange',
      loc.purple: 'purple',
      loc.pink: 'pink',
      loc.brown: 'brown',
      loc.teal: 'teal',
      loc.navy: 'navy',
      loc.maroon: 'maroon',
      loc.olive: 'olive',
      loc.lime: 'lime',
    };

    // First try to get the color directly from the colorMap (for English keys)
    if (colorMap.containsKey(colorString.toLowerCase())) {
      return colorMap[colorString.toLowerCase()]!;
    }

    // If not found, try to map from localized name to English key
    final englishKey = localizedToEnglish[colorString.toLowerCase()] ?? 'white';
    return colorMap[englishKey] ?? white;
  }

  // get string from pre defined set of Colors with given color
  // default to white
  String getStringFromColor(Color color, BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) return 'white';

    // Map English keys to localized color names
    final Map<String, String> englishToLocalized = {
      'black': loc.black,
      'darkgrey': loc.darkGrey,
      'lightgrey': loc.lightGrey,
      'white': loc.white,
      'darkbrown': loc.darkBrown,
      'lightbrown': loc.lightBrown,
      'darkblue': loc.darkBlue,
      'lightblue': loc.lightBlue,
      'darkgreen': loc.darkGreen,
      'lightgreen': loc.lightGreen,
      'red': loc.red,
      'blue': loc.blue,
      'green': loc.green,
      'yellow': loc.yellow,
      'orange': loc.orange,
      'purple': loc.purple,
      'pink': loc.pink,
      'brown': loc.brown,
      'teal': loc.teal,
      'navy': loc.navy,
      'maroon': loc.maroon,
      'olive': loc.olive,
      'lime': loc.lime,
    };

    final englishKey = colorMap.entries
        .firstWhere((entry) => entry.value == color,
            orElse: () => MapEntry('white', white))
        .key;
    return englishToLocalized[englishKey] ?? loc.white;
  }

  // Get localized color name with given english key and context 
  // Parameters:
  //    englishKey: key of english name 
  //    context: BuildContext used to get localization 
  String getLocalizedColorName(String englishKey, BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) return englishKey;
    final englishToLocalized = {
      'black': loc.black,
      'darkgrey': loc.darkGrey,
      'lightgrey': loc.lightGrey,
      'white': loc.white,
      'darkbrown': loc.darkBrown,
      'lightbrown': loc.lightBrown,
      'darkblue': loc.darkBlue,
      'lightblue': loc.lightBlue,
      'darkgreen': loc.darkGreen,
      'lightgreen': loc.lightGreen,
      'red': loc.red,
      'blue': loc.blue,
      'green': loc.green,
      'yellow': loc.yellow,
      'orange': loc.orange,
      'purple': loc.purple,
      'pink': loc.pink,
      'brown': loc.brown,
      'teal': loc.teal,
      'navy': loc.navy,
      'maroon': loc.maroon,
      'olive': loc.olive,
      'lime': loc.lime,
    };
    return englishToLocalized[englishKey] ?? englishKey;
  }
}
