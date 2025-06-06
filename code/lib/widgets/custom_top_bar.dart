/// A custom top bar widget that displays weather information and filtering controls.
/// This widget shows the current weather condition, temperature range, and provides
/// filtering functionality for outfits.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outfit_finder/weather_conditions.dart';
import 'package:outfit_finder/providers/weather_provider.dart';

/// A custom top bar widget that displays weather information and controls.
class CustomTopBar extends StatelessWidget {
  /// Callback function triggered when the filter button is pressed
  final VoidCallback onFilterPressed;
  
  /// Callback function triggered when a weather filter is selected
  final void Function(WeatherCondition?) onWeatherFilterSelected;
  
  /// Flag indicating if the weather filter is currently active
  final bool isFilterActive;

  /// Creates a new CustomTopBar instance.
  /// 
  /// Parameters:
  /// - onFilterPressed: Callback for filter button press
  /// - onWeatherFilterSelected: Callback for weather filter selection
  /// - isFilterActive: Current state of the filter
  const CustomTopBar({
    super.key, 
    required this.onFilterPressed, 
    required this.onWeatherFilterSelected,
    required this.isFilterActive,
  });

  @override
  Widget build(BuildContext context) {
    // Get current weather information from provider
    final weather = context.watch<WeatherProvider>().condition;
    final lowTemp = context.watch<WeatherProvider>().lowTempFahrenheit;
    final highTemp = context.watch<WeatherProvider>().highTempFahrenheit;
    
    return Container(
      padding: const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 8),
      decoration: BoxDecoration(
        gradient: _getWeatherGradient(weather),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weather condition and filter controls row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Weather condition display
              Row(
                children: [
                  Icon(_getWeatherIcon(weather), size: 32),
                  const SizedBox(width: 8),
                  Text(
                    weather == WeatherCondition.unknown ? 'Any' : weather.toString(),
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // Filter and add buttons
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isFilterActive ? _getFilterActiveColor(weather) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        size: 28,
                        color: isFilterActive ? Colors.white : Colors.black87,
                      ),
                      onPressed: () {
                        if (isFilterActive) {
                          onWeatherFilterSelected(null); // Reset to show all
                        } else {
                          onWeatherFilterSelected(weather); // Filter to current weather
                        }
                        onFilterPressed();
                      },
                      tooltip: 'Filter by current weather',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 28),
                    onPressed: () {},
                    tooltip: 'Add outfit',
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          // Temperature range display
          Row(
            children: [
              Text(
                highTemp != 0 ? '$highTemp°' : '--',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              const SizedBox(width: 6),
              Container(
                width: 40,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB2EBF2), Color(0xFFFFAB91)],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                lowTemp != 0 ? '$lowTemp°' : '--',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Gets the color for the active filter button based on weather condition.
  /// 
  /// Parameters:
  /// - condition: The current weather condition
  /// Returns: A color that provides good contrast against the weather gradient
  Color _getFilterActiveColor(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return const Color(0xFF795548); // Brown for contrast against yellow
      case WeatherCondition.gloomy:
        return const Color(0xFF263238); // Very dark blue-gray for contrast against gray
      case WeatherCondition.rainy:
        return const Color(0xFF0D47A1); // Deep blue for contrast against light blue
      case WeatherCondition.slightlyCloudy:
        return const Color(0xFF37474F); // Dark blue-gray for contrast against light gray
      case WeatherCondition.unknown:
        return Colors.black;
    }
  }

  /// Gets the appropriate weather icon for the current condition.
  /// 
  /// Parameters:
  /// - condition: The current weather condition
  /// Returns: An IconData representing the weather condition
  IconData _getWeatherIcon(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return Icons.wb_sunny;
      case WeatherCondition.gloomy:
        return Icons.cloud;
      case WeatherCondition.rainy:
        return Icons.beach_access;
      case WeatherCondition.slightlyCloudy:
        return Icons.cloud_queue;
      case WeatherCondition.unknown:
        return Icons.help_outline;
    }
  }

  /// Gets the gradient background for the top bar based on weather condition.
  /// 
  /// Parameters:
  /// - condition: The current weather condition
  /// Returns: A LinearGradient appropriate for the weather condition
  LinearGradient _getWeatherGradient(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return const LinearGradient(
          colors: [Color(0xFFFFE066), Color(0xFFFFF9C4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case WeatherCondition.gloomy:
        return const LinearGradient(
          colors: [Color(0xFFB0BEC5), Color(0xFFECEFF1)], // gray gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case WeatherCondition.rainy:
        return const LinearGradient(
          colors: [Color(0xFF64B5F6), Color(0xFFB3E5FC)], // blue gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case WeatherCondition.slightlyCloudy:
        return const LinearGradient(
          colors: [Color(0xFFCFD8DC), Color(0xFFECEFF1)], // light gray
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case WeatherCondition.unknown:
        return const LinearGradient(
          colors: [Color(0xFFF5F5F5), Color(0xFFE0E0E0)], // neutral
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
} 