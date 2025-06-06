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

/// The root widget of the Outfit Finder application.
/// Manages the database provider and overall app structure.
class OutFitFinderApp extends StatefulWidget {
  /// Database provider for managing outfits and clothing items
  final DatabaseProvider venues;

  /// Creates a new OutFitFinderApp instance.
  /// 
  /// Parameters:
  /// - venues: The database provider for managing outfits
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

  @override
  void initState() {
    super.initState();
    _outfitsFuture = widget.venues.getAllOutfits();
  }

  /// Filters the list of outfits based on the selected weather condition.
  /// 
  /// Parameters:
  /// - outfits: The list of outfits to filter
  /// Returns: A filtered list of outfits matching the weather condition
  List<Outfit> _filterOutfits(List<Outfit> outfits) {
    if (_selectedWeatherFilter == null) return outfits;
    
    switch (_selectedWeatherFilter) {
      case WeatherCondition.sunny:
        return outfits.where((o) => o.isForSunny).toList();
      case WeatherCondition.gloomy:
        return outfits.where((o) => o.isForGloomy).toList();
      case WeatherCondition.rainy:
        return outfits.where((o) => o.isForRainy).toList();
      case WeatherCondition.slightlyCloudy:
        return outfits; // Show all outfits for slightly cloudy weather
      default:
        return outfits;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) return const SizedBox.shrink();

    return Scaffold(
      body: FutureBuilder<List<Outfit>>(
        future: _outfitsFuture,
        builder: (context, snapshot) {
          // Show loading indicator while fetching outfits
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          // Show error message if fetching failed
          if (snapshot.hasError) {
            return Center(
              child: Text('${loc.error}: ${snapshot.error}'),
            );
          }
          
          final outfits = snapshot.data ?? [];
          
          // Show message if no outfits are available
          if (outfits.isEmpty) {
            return Center(
              child: Text(loc.noItemsAvailable),
            );
          }
          
          // Filter outfits based on selected weather condition
          final filteredOutfits = _filterOutfits(outfits);
          
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
    );
  }
}
