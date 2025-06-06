/// Main application widget for the Outfit Finder app.
/// This widget manages the overall app structure and outfit filtering functionality.
import 'package:flutter/material.dart';
import 'package:outfit_finder/providers/database_provider.dart';
import 'package:outfit_finder/components/weather_filter.dart';
import 'package:outfit_finder/models/outfit.dart';
import 'package:outfit_finder/widgets/custom_top_bar.dart';
import 'package:outfit_finder/weather_conditions.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:outfit_finder/views/outfit_view.dart';
import 'package:provider/provider.dart';

/// The root widget of the Outfit Finder application.
/// Manages the database provider and overall app structure.
class OutFitFinderApp extends StatefulWidget {
  /// The database provider instance
  final DatabaseProvider venues;

  /// Creates a new OutFitFinderApp instance.
  /// 
  /// Parameters:
  /// - venues: The database provider instance
  const OutFitFinderApp({super.key, required this.venues});

  @override
  State<OutFitFinderApp> createState() => _OutFitFinderAppState();
}

/// State class for the OutFitFinderApp widget.
/// Handles outfit filtering and UI state management.
class _OutFitFinderAppState extends State<OutFitFinderApp> {
  /// Future that holds the list of all outfits
  late Future<List<Outfit>> _outfitsFuture;
  
  /// Currently selected weather filter condition
  WeatherCondition? _selectedWeatherFilter;
  
  /// Flag indicating if the weather filter is currently active
  bool _isFilterActive = false;

  /// Current locale of the app
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _outfitsFuture = widget.venues.getAllOutfits();
  }

  /// Sets the app's locale
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  /// Filters the list of outfits based on the selected weather condition.
  /// 
  /// Parameters:
  /// - outfits: The list of outfits to filter
  /// Returns: A filtered list of outfits matching the weather condition
  List<Outfit> _filterOutfits(List<Outfit> outfits) {
    if (_selectedWeatherFilter == null) {
      return outfits;
    }

    return outfits.where((outfit) {
      switch (_selectedWeatherFilter) {
        case WeatherCondition.sunny:
          return outfit.isForSunny;
        case WeatherCondition.rainy:
          return outfit.isForRainy;
        case WeatherCondition.gloomy:
          return outfit.isForGloomy;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outfit Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: FutureBuilder<List<Outfit>>(
          future: _outfitsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No outfits found'));
            }

            final filteredOutfits = _filterOutfits(snapshot.data!);
            return Column(
              children: [
                CustomTopBar(
                  onFilterPressed: () {
                    setState(() {
                      _isFilterActive = !_isFilterActive;
                    });
                  },
                  onWeatherFilterSelected: (condition) {
                    setState(() {
                      _selectedWeatherFilter = condition;
                    });
                  },
                  isFilterActive: _isFilterActive,
                ),
                Expanded(child: WeatherFilter(outfits: filteredOutfits)),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OutfitView(outfit: Outfit(name: '')),
              ),
            ).then((_) {
              setState(() {
                _outfitsFuture = widget.venues.getAllOutfits();
              });
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}