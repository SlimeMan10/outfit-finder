import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:outfit_finder/providers/position_provider.dart';
import 'package:outfit_finder/providers/weather_provider.dart';
import 'package:outfit_finder/views/outfit_finder_app.dart';
import 'package:provider/provider.dart';
import 'package:outfit_finder/models/outfit_db.dart';

/// Load all of the venues from the JSON file into the Venues DB
/// This is an asynchronous call since we're going to a secondary
/// storage resource to get the data.
/// Parameters
/// - dataPath: the path to the venues.json file.
/// Returns: a Future that when resolved will have a VenuesDB object
/// with our venue information.
Future<OutfitDB> loadVenuesDB(String dataPath) async {
  return OutfitDB.initializeFromJson(await rootBundle.loadString(dataPath));
}

void main() {
  // Location of the venues.json file.
  const dataPath = 'assets/venues.json';

  // Ensure that the flutter framework is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // when the asynchronous method returns we'll have a Venues DB that we can use!
  loadVenuesDB(dataPath).then((value) => runApp(
    MultiProvider(
      providers: [
        // The PositionProvider is used to get the current location of the user
        // and to update the location when the user moves.
        // The WeatherProvider is used to get the current weather information
        // and to update the weather information when the user moves.
        ChangeNotifierProvider(create: (context) => PositionProvider()),
        ChangeNotifierProvider(create: (context) => WeatherProvider()),
      ],
      child: OutFitFinderApp(venues: value),
    ),
  ));
}