import 'package:flutter/material.dart';
import 'package:outfit_finder/models/outfit.dart';
import 'package:outfit_finder/weather_conditions.dart';
import 'package:provider/provider.dart';
import 'package:outfit_finder/providers/weather_provider.dart';
import 'package:outfit_finder/widgets/outfit_card.dart';
import 'package:outfit_finder/views/outfit_view.dart';

/// A component that displays outfits filtered by weather condition
class WeatherFilter extends StatefulWidget {
  /// List of all outfits to filter
  final List<Outfit> outfits;

  /// Creates a WeatherFilter
  const WeatherFilter({super.key, required this.outfits});

  @override
  State<WeatherFilter> createState() => _WeatherFilterState();
}

class _WeatherFilterState extends State<WeatherFilter> {
  final WeatherCondition _selectedCondition = WeatherCondition.unknown;

  @override
  Widget build(BuildContext context) {
    print('WeatherFilter: Building widget');
    return _buildOutfitsList();
  }

  /// Builds the list of filtered outfits
  Widget _buildOutfitsList() {
    return ListView.builder(
      itemCount: widget.outfits.length,
      itemBuilder: _buildOutfitItem,
    );
  }

  /// Builds a single outfit item in the list
  Widget _buildOutfitItem(BuildContext context, int index) {
    final outfit = widget.outfits[index];
    final currentWeather = context.watch<WeatherProvider>().condition;
    if (!_matchesWeatherCondition(outfit)) {
      return const SizedBox.shrink();
    }
    return OutfitCard(outfit: outfit, currentWeather: currentWeather);
  }

  /// Checks if an outfit matches the selected weather condition
  bool _matchesWeatherCondition(Outfit outfit) {
    switch (_selectedCondition) {
      case WeatherCondition.sunny:
        return outfit.isForSunny;
      case WeatherCondition.gloomy:
        return outfit.isForGloomy;
      case WeatherCondition.rainy:
        return outfit.isForRainy;
      case WeatherCondition.unknown:
      case WeatherCondition.slightlyCloudy:
        return true; // Show all outfits for unknown/slightly cloudy
    }
  }

  /// Navigates to the outfit editing view.
  /// 
  /// Parameters:
  /// - context: The build context
  /// - outfit: The outfit to edit
  Future<void> _navigateToOutfit(BuildContext context, Outfit outfit) async {
    print('WeatherFilter: Attempting to navigate to OutfitView');
    try {
      await Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            print('WeatherFilter: Building OutfitView route');
            return OutfitView(outfit: outfit);
          }));
      print('WeatherFilter: Successfully returned from OutfitView');
    } catch (e) {
      print('WeatherFilter: Error navigating to OutfitView: $e');
    }
  }
} 