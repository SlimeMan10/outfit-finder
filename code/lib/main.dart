import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:outfit_finder/providers/position_provider.dart';
import 'package:outfit_finder/providers/weather_provider.dart';
import 'package:outfit_finder/providers/database_provider.dart';
import 'package:outfit_finder/views/outfit_finder_app.dart';
import 'package:provider/provider.dart';
import 'package:outfit_finder/helper/isar_helper.dart';

/// Initialize the database and load data
/// This is an asynchronous call since we're going to a secondary
/// storage resource to get the data.
Future<DatabaseProvider> initializeDatabase() async {
  await initializeIsar();
  final dbProvider = DatabaseProvider();
  await dbProvider.loadData();
  return dbProvider;
}

void main() async {
  // Ensure that the flutter framework is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  await initializeIsar();
  
  // Create providers
  final dbProvider = DatabaseProvider();
  await dbProvider.loadData();

  runApp(
    MultiProvider(
      providers: [
        // The PositionProvider is used to get the current location of the user
        // and to update the location when the user moves.
        // The WeatherProvider is used to get the current weather information
        // and to update the weather information when the user moves.
        ChangeNotifierProvider(create: (context) => PositionProvider()),
        ChangeNotifierProvider(create: (context) => WeatherProvider()),
        ChangeNotifierProvider.value(value: dbProvider),
      ],
      child: OutFitFinderApp(venues: dbProvider),
    ),
  );
}