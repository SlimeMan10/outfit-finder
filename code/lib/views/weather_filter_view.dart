import 'package:flutter/material.dart';
import 'package:outfit_finder/models/outfit.dart';
import 'package:outfit_finder/weather_conditions.dart';
import 'package:provider/provider.dart';
import 'package:outfit_finder/providers/weather_provider.dart';
import 'package:outfit_finder/widgets/outfit_card.dart';

/// A view that displays outfits filtered by weather condition
class WeatherFilterView extends StatefulWidget {
  /// List of all outfits to filter
  final List<Outfit> outfits;

  /// Creates a WeatherFilterView
  const WeatherFilterView({super.key, required this.outfits});

  @override
  State<WeatherFilterView> createState() => _WeatherFilterViewState();
}

class _WeatherFilterViewState extends State<WeatherFilterView> {
  WeatherCondition _selectedCondition = WeatherCondition.unknown;

  @override
  Widget build(BuildContext context) {
    final currentWeather = context.watch<WeatherProvider>().condition;
    
    return Column(
      children: [
        // Weather condition selector
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

        // Current weather suggestion
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

        // Filtered outfits list
        Expanded(
          child: ListView.builder(
            itemCount: widget.outfits.length,
            itemBuilder: (context, index) {
              final outfit = widget.outfits[index];
              
              // Check if outfit matches selected weather condition
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

              if (!matchesCondition) {
                return const SizedBox.shrink(); // Hide non-matching outfits
              }
              return OutfitCard(outfit: outfit, currentWeather: currentWeather);
            },
          ),
        ),
      ],
    );
  }
} 