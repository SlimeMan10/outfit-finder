// A view that displays outfits filtered by weather condition.
// This widget provides a dropdown to select weather conditions and displays
// outfits that match the selected condition.
import 'package:flutter/material.dart';
import 'package:outfit_finder/models/outfit.dart';
import 'package:outfit_finder/weather_conditions.dart';
import 'package:provider/provider.dart';
import 'package:outfit_finder/providers/weather_provider.dart';
import 'package:outfit_finder/widgets/outfit_card.dart';

/// Widget that displays and filters outfits based on weather conditions.
class WeatherFilterView extends StatefulWidget {
  /// List of all outfits to be filtered
  final List<Outfit> outfits;

  /// Creates a new WeatherFilterView instance.
  /// 
  /// Parameters:
  /// - outfits: The list of outfits to filter
  const WeatherFilterView({super.key, required this.outfits});

  @override
  State<WeatherFilterView> createState() => _WeatherFilterViewState();
}

/// State class for the WeatherFilterView widget.
/// Manages the selected weather condition and outfit filtering logic.
class _WeatherFilterViewState extends State<WeatherFilterView> {
  /// Currently selected weather condition for filtering
  WeatherCondition _selectedCondition = WeatherCondition.unknown;

  @override
  Widget build(BuildContext context) {
    // Get current weather from provider
    final currentWeather = context.watch<WeatherProvider>().condition;
    
    return Column(
      children: [
        // Weather condition selector dropdown
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButton<WeatherCondition>(
            value: _selectedCondition,
            hint: const Text('Select Weather Condition'),
            isExpanded: true,
            items: WeatherCondition.values.map((condition) {
              return DropdownMenuItem(
                value: condition,
                child: Text(condition.toString()),
              );
            }).toList(),
            onChanged: (WeatherCondition? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedCondition = newValue;
                });
              }
            },
          ),
        ),

        // Button to use current weather condition
        if (currentWeather != WeatherCondition.unknown)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _selectedCondition = currentWeather;
                });
              },
              child: Text('Use Current Weather: ${currentWeather.toString()}'),
            ),
          ),

        // List of filtered outfits
        Expanded(
          child: ListView.builder(
            itemCount: widget.outfits.length,
            itemBuilder: (context, index) {
              final outfit = widget.outfits[index];
              
              // Determine if outfit matches selected weather condition
              bool matchesCondition = false;
              switch (_selectedCondition) {
                case WeatherCondition.sunny:
                  matchesCondition = outfit.isForSunny;
                  break;
                case WeatherCondition.gloomy:
                  matchesCondition = outfit.isForGloomy;
                  break;
                case WeatherCondition.rainy:
                  matchesCondition = outfit.isForRainy;
                  break;
                case WeatherCondition.unknown:
                case WeatherCondition.slightlyCloudy:
                  matchesCondition = true; // Show all outfits for unknown/slightly cloudy
                  break;
              }

              // Hide outfits that don't match the selected condition
              if (!matchesCondition) {
                return const SizedBox.shrink();
              }
              return OutfitCard(outfit: outfit, currentWeather: currentWeather);
            },
          ),
        ),
      ],
    );
  }
} 