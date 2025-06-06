/// A custom top bar widget that displays weather information and filtering controls.
/// This widget shows the current weather condition, temperature range, and provides
/// filtering functionality for outfits.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outfit_finder/weather_conditions.dart';
import 'package:outfit_finder/providers/weather_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:outfit_finder/main.dart';
import 'package:outfit_finder/providers/locale_change_notifier.dart';
import 'package:outfit_finder/views/outfit_view.dart';
import 'package:outfit_finder/models/outfit.dart';

/// A custom top bar widget that displays weather information and controls.
class CustomTopBar extends StatelessWidget {
  /// Callback function triggered when the filter button is pressed
  final VoidCallback onFilterPressed;
  /// Callback function triggered when a weather filter is selected
  final void Function(WeatherCondition?) onWeatherFilterSelected;
  /// Flag indicating if the weather filter is currently active
  final bool isFilterActive;
  /// Callback to refresh the parent view after adding an outfit
  final VoidCallback? onAddOutfit;
  /// Callback to refresh the parent view after any add/edit/delete
  final VoidCallback? onRefresh;

  /// Creates a new CustomTopBar instance.
  ///
  /// Parameters:
  /// - onFilterPressed: Callback for filter button press
  /// - onWeatherFilterSelected: Callback for weather filter selection
  /// - isFilterActive: Current state of the filter
  /// - onAddOutfit: Callback to refresh after adding an outfit
  /// - onRefresh: Callback to refresh after any add/edit/delete
  const CustomTopBar({
    super.key,
    required this.onFilterPressed,
    required this.onWeatherFilterSelected,
    required this.isFilterActive,
    this.onAddOutfit,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    // Get current weather information from provider
    final weather = context.watch<WeatherProvider>().condition;
    final temp = context.watch<WeatherProvider>().tempInFahrenheit;
    final lowTemp = context.watch<WeatherProvider>().lowTempFahrenheit;
    final highTemp = context.watch<WeatherProvider>().highTempFahrenheit;
    final loc = AppLocalizations.of(context);
    
    final textColor = _getTextColor(weather);
    final borderColor = _getBorderColor(weather);
    
    return Container(
      padding: const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 8),
      decoration: BoxDecoration(
        gradient: _getWeatherGradient(weather),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getWeatherIcon(weather),
                    size: 32,
                    color: textColor,
                    semanticLabel: loc?.todaysWeather(_localizedWeatherLabel(context, weather)),
                  ),
                  const SizedBox(width: 8),
                  Semantics(
                    label: loc?.todaysWeather(_localizedWeatherLabel(context, weather)),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Calculate if text would overflow
                          final textSpan = TextSpan(
                            text: _localizedWeatherLabel(context, weather),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                          final textPainter = TextPainter(
                            text: textSpan,
                            textDirection: TextDirection.ltr,
                          )..layout();
                          
                          // If text would overflow, use smaller font size
                          final fontSize = textPainter.width > constraints.maxWidth ? 10.0 : 28.0;
                          
                          return Text(
                            _localizedWeatherLabel(context, weather),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // Language Switcher Button
                  Semantics(
                    label: loc?.changeLanguage,
                    button: true,
                    child: IconButton(
                      icon: Icon(
                        Icons.language,
                        color: textColor,
                        semanticLabel: loc?.changeLanguage,
                      ),
                      onPressed: () => _showLanguageDialog(context),
                      tooltip: loc?.changeLanguage,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: isFilterActive ? _getFilterActiveColor(weather) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Semantics(
                      label: loc?.weatherConditions,
                      button: true,
                      child: IconButton(
                        icon: Icon(
                          Icons.filter_list,
                          size: 28,
                          color: isFilterActive ? Colors.white : textColor,
                          semanticLabel: loc?.weatherConditions,
                        ),
                        onPressed: () {
                          if (isFilterActive) {
                            onWeatherFilterSelected(null); // Reset to show all
                          } else {
                            onWeatherFilterSelected(weather); // Filter to current weather
                          }
                          onFilterPressed();
                        },
                        tooltip: loc?.weatherConditions,
                      ),
                    ),
                  ),
                  Semantics(
                    label: loc?.addNewOutfit,
                    button: true,
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        size: 28,
                        color: textColor,
                        semanticLabel: loc?.addNewOutfit,
                      ),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OutfitView(outfit: Outfit(name: ''), onRefresh: onRefresh),
                          ),
                        );
                        if (onAddOutfit != null) onAddOutfit!();
                      },
                      tooltip: loc?.addNewOutfit,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Semantics(
                label: "Today's high temperature: ${highTemp != 0 ? '$highTemp°' : '--'}",
                child: Text(
                  highTemp != 0 ? '$highTemp°' : '--',
                  style: TextStyle(
                    fontSize: 18,
                    color: textColor,
                  ),
                ),
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
                  border: Border.all(color: borderColor, width: 1),
                ),
              ),
              const SizedBox(width: 6),
              Semantics(
                label: "Today's low temperature: ${lowTemp != 0 ? '$lowTemp°' : '--'}",
                child: Text(
                  lowTemp != 0 ? '$lowTemp°' : '--',
                  style: TextStyle(
                    fontSize: 18,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc?.selectLanguage ?? 'Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                context.read<LocaleChangeNotifier>().setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Español'),
              onTap: () {
                context.read<LocaleChangeNotifier>().setLocale(const Locale('es'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
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

  String _localizedWeatherLabel(BuildContext context, WeatherCondition condition) {
    final loc = AppLocalizations.of(context);
    
    switch (condition) {
      case WeatherCondition.sunny:
        return loc?.sunny ?? 'Sunny';
      case WeatherCondition.gloomy:
        return loc?.cloudyDay ?? 'Cloudy';
      case WeatherCondition.rainy:
        return loc?.rainyDay ?? 'Rainy';
      case WeatherCondition.slightlyCloudy:
        return loc?.partlyCloudy ?? 'Partly Cloudy';
      case WeatherCondition.unknown:
        return loc?.unknown ?? 'Unknown';
    }
  }

  Color _getTextColor(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return const Color(0xFF1A1A1A); // Dark gray for yellow background
      case WeatherCondition.gloomy:
        return const Color(0xFF1A1A1A); // Dark gray for gray background
      case WeatherCondition.rainy:
        return Colors.white; // White for blue background
      case WeatherCondition.slightlyCloudy:
        return const Color(0xFF1A1A1A); // Dark gray for light gray background
      case WeatherCondition.unknown:
        return const Color(0xFF1A1A1A); // Dark gray for neutral background
    }
  }

  Color _getBorderColor(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return const Color(0xFF424242); // Darker gray for yellow background
      case WeatherCondition.gloomy:
        return const Color(0xFF424242); // Darker gray for gray background
      case WeatherCondition.rainy:
        return Colors.white; // White for blue background
      case WeatherCondition.slightlyCloudy:
        return const Color(0xFF424242); // Darker gray for light gray background
      case WeatherCondition.unknown:
        return const Color(0xFF424242); // Darker gray for neutral background
    }
  }
}