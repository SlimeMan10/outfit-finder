/// Main entry point for the Outfit Finder application.
/// This file handles initialization of the app, including database setup,
/// provider configuration, and app launch.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:outfit_finder/providers/position_provider.dart';
import 'package:outfit_finder/providers/weather_provider.dart';
import 'package:outfit_finder/providers/database_provider.dart';
import 'package:outfit_finder/providers/locale_change_notifier.dart';
import 'package:outfit_finder/views/outfit_finder_app.dart';
import 'package:provider/provider.dart';
import 'package:outfit_finder/helper/isar_helper.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  
  // Check if database is empty and populate with sample data if needed
  final outfits = await dbProvider.getAllOutfits();
  if (outfits.isEmpty) {
    await dbProvider.addSampleOutfits();
  }
  
  // Launch the app with configured providers
  runApp(MyApp(databaseProvider: dbProvider));
}

class MyApp extends StatefulWidget {
  final DatabaseProvider databaseProvider;

  const MyApp({super.key, required this.databaseProvider});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _localeNotifier = LocaleChangeNotifier();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PositionProvider()),
        ChangeNotifierProvider(create: (context) => WeatherProvider()),
        ChangeNotifierProvider.value(value: widget.databaseProvider),
        ChangeNotifierProvider.value(value: _localeNotifier),
      ],
      child: Consumer<LocaleChangeNotifier>(
        builder: (context, localeNotifier, _) => MaterialApp(
          title: 'Outfit Finder',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          locale: localeNotifier.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('es'), // Spanish
          ],
          home: OutFitFinderApp(venues: widget.databaseProvider),
        ),
      ),
    );
  }
}