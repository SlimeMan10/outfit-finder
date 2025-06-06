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
          _buildWeatherConditionRow(weather),
          const SizedBox(height: 8),
          _buildTemperatureDisplay(weather, highTemp, lowTemp),
        ],
      ),
    );
  }

  /// Builds the row containing weather condition and filter controls.
  /// 
  /// Parameters:
  /// - weather: Current weather condition
  /// Returns: A row widget with weather icon, condition text, and filter controls
  Widget _buildWeatherConditionRow(WeatherCondition weather) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWeatherConditionDisplay(weather),
        _buildFilterControls(weather),
      ],
    );
  }

  /// Builds the weather condition display with icon and text.
  /// 
  /// Parameters:
  /// - weather: Current weather condition
  /// Returns: A row widget with weather icon and condition text
  Widget _buildWeatherConditionDisplay(WeatherCondition weather) {
    return Row(
      children: [
        Icon(_getWeatherIcon(weather), size: 32),
        const SizedBox(width: 8),
        Text(
          weather == WeatherCondition.unknown ? 'Any' : weather.toString(),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  /// Builds the filter and add buttons.
  /// 
  /// Parameters:
  /// - weather: Current weather condition
  /// Returns: A row widget containing filter and add buttons
  Widget _buildFilterControls(WeatherCondition weather) {
    return Row(
      children: [
        _buildFilterButton(weather),
        IconButton(
          icon: const Icon(Icons.add, size: 28),
          onPressed: () {},
          tooltip: 'Add outfit',
        ),
      ],
    );
  }

  /// Builds the filter button with appropriate styling.
  /// 
  /// Parameters:
  /// - weather: Current weather condition
  /// Returns: A container widget containing the filter button
  Widget _buildFilterButton(WeatherCondition weather) {
    return Container(
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
    );
  }

  /// Builds the temperature display with high and low temperatures.
  /// 
  /// Parameters:
  /// - weather: Current weather condition
  /// - highTemp: High temperature in Fahrenheit
  /// - lowTemp: Low temperature in Fahrenheit
  /// Returns: A container widget displaying temperature range
  Widget _buildTemperatureDisplay(WeatherCondition weather, int highTemp, int lowTemp) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: _getContrastingBorderColor(weather),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTemperatureText(weather, highTemp, true),
          const SizedBox(width: 6),
          _buildTemperatureGradient(),
          const SizedBox(width: 6),
          _buildTemperatureText(weather, lowTemp, false),
        ],
      ),
    );
  }

  /// Builds the temperature text with appropriate styling.
  /// 
  /// Parameters:
  /// - weather: Current weather condition
  /// - temperature: Temperature value in Fahrenheit
  /// - isHigh: Whether this is the high temperature
  /// Returns: A text widget displaying the temperature
  Widget _buildTemperatureText(WeatherCondition weather, int temperature, bool isHigh) {
    return Text(
      temperature != 0 ? '$temperature°' : '--',
      style: TextStyle(
        fontSize: 18,
        color: _getContrastingTextColor(weather),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Builds the temperature gradient bar.
  /// 
  /// Returns: A container widget displaying the temperature gradient
  Widget _buildTemperatureGradient() {
    return Container(
      width: 40,
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        gradient: const LinearGradient(
          colors: [Color(0xFFB2EBF2), Color(0xFFFFAB91)],
        ),
      ),
    );
  }

  /// Gets a contrasting border color based on the weather condition.
  /// The color is chosen to meet WCAG contrast requirements against the background.
  /// 
  /// Parameters:
  /// - condition: The current weather condition
  /// Returns: A color that provides sufficient contrast against the background
  Color _getContrastingBorderColor(WeatherCondition condition) {
    final gradient = _getWeatherGradient(condition);
    final baseColor = gradient.colors.first;
    
    // Calculate a contrasting color based on the background
    return HSLColor.fromColor(baseColor).withLightness(0.2).toColor();
  }

  /// Gets a contrasting text color based on the weather condition.
  /// The color is chosen to meet WCAG contrast requirements against the background.
  /// 
  /// Parameters:
  /// - condition: The current weather condition
  /// Returns: A color that provides sufficient contrast for text against the background
  Color _getContrastingTextColor(WeatherCondition condition) {
    final gradient = _getWeatherGradient(condition);
    final baseColor = gradient.colors.first;
    
    // Calculate a contrasting color based on the background
    return HSLColor.fromColor(baseColor).withLightness(0.1).toColor();
  }

  /// Gets the color for the active filter button based on weather condition.
  /// 
  /// Parameters:
  /// - condition: The current weather condition
  /// Returns: A color that provides good contrast against the weather gradient
  Color _getFilterActiveColor(WeatherCondition condition) {
    final gradient = _getWeatherGradient(condition);
    final baseColor = gradient.colors.first;
    
    // Calculate a contrasting color based on the background
    return HSLColor.fromColor(baseColor).withLightness(0.3).toColor();
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