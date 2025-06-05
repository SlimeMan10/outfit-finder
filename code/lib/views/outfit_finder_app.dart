import 'package:flutter/material.dart';
import 'package:outfit_finder/providers/database_provider.dart';
import 'package:outfit_finder/components/weather_filter.dart';
import 'package:outfit_finder/models/outfit.dart';
import 'package:outfit_finder/widgets/custom_top_bar.dart';
import 'package:outfit_finder/weather_conditions.dart';

class OutFitFinderApp extends StatefulWidget {
  final DatabaseProvider venues;

  const OutFitFinderApp({super.key, required this.venues});

  @override
  State<OutFitFinderApp> createState() => _OutFitFinderAppState();
}

class _OutFitFinderAppState extends State<OutFitFinderApp> {
  int _selectedIndex = 0;
  late Future<List<Outfit>> _outfitsFuture;
  WeatherCondition? _selectedWeatherFilter;
  bool _isFilterActive = false;

  @override
  void initState() {
    super.initState();
    _outfitsFuture = widget.venues.getAllOutfits();
  }

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
        return outfits; // Show all for slightly cloudy
      default:
        return outfits;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outfit Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: FutureBuilder<List<Outfit>>(
          future: _outfitsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            final outfits = snapshot.data ?? [];
            if (outfits.isEmpty) {
              return const Center(
                child: Text('No outfits available'),
              );
            }
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
      ),
    );
  }
}
