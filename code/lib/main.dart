/// Main entry point for the Outfit Finder application.
/// This file handles initialization of the app, including database setup,
/// provider configuration, and app launch.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:outfit_finder/providers/position_provider.dart';
import 'package:outfit_finder/providers/weather_provider.dart';
import 'package:outfit_finder/providers/database_provider.dart';
import 'package:outfit_finder/views/outfit_finder_app.dart';
import 'package:provider/provider.dart';
import 'package:outfit_finder/helper/isar_helper.dart';

/// Initializes the database and loads initial data.
/// 
/// This function performs the following tasks:
/// 1. Initializes the Isar database
/// 2. Creates a new DatabaseProvider instance
/// 3. Loads existing data from the database
/// 
/// Returns: A configured DatabaseProvider instance ready for use
Future<DatabaseProvider> initializeDatabase() async {
  await initializeIsar();
  final dbProvider = DatabaseProvider();
  await dbProvider.loadData();
  return dbProvider;
}

/// Main function that bootstraps the application.
/// 
/// This function:
/// 1. Initializes Flutter bindings
/// 2. Sets up the database with sample data
/// 3. Configures providers for state management
/// 4. Launches the main application widget
void main() async {
  // Ensure that the flutter framework is initialized before any platform-specific code
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the local database
  await initializeIsar();
  
  // Create and configure the database provider
  final dbProvider = DatabaseProvider();
  
  // Reset database and populate with sample data for testing
  await dbProvider.clearDatabase();
  await dbProvider.addSampleOutfits();
  
  // Launch the app with configured providers
  runApp(
    MultiProvider(
      providers: [
        // Provider for managing user location and updates
        ChangeNotifierProvider(create: (context) => PositionProvider()),
        // Provider for managing weather data and updates
        ChangeNotifierProvider(create: (context) => WeatherProvider()),
        // Provider for managing database operations
        ChangeNotifierProvider.value(value: dbProvider),
      ],
      child: OutFitFinderApp(venues: dbProvider),
    ),
  );
}