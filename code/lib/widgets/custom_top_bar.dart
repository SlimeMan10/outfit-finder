import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outfit_finder/weather_conditions.dart';
import 'package:outfit_finder/providers/weather_provider.dart';

class CustomTopBar extends StatelessWidget {
  final VoidCallback onFilterPressed;
  const CustomTopBar({super.key, required this.onFilterPressed});

  @override
  Widget build(BuildContext context) {
    final weather = context.watch<WeatherProvider>().condition;
    final temp = context.watch<WeatherProvider>().tempInFahrenheit;
    return Container(
      padding: const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFE066), Color(0xFFFFF9C4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(_getWeatherIcon(weather), size: 28),
              const SizedBox(width: 8),
              Text(
                weather == WeatherCondition.unknown ? 'Any' : weather.toString(),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (temp != 0) ...[
                const SizedBox(width: 8),
                Text('${temp.toString()}°', style: const TextStyle(fontSize: 18)),
              ]
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: onFilterPressed,
                tooltip: 'Filter by weather',
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
                tooltip: 'Add outfit',
              ),
            ],
          )
        ],
      ),
    );
  }

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
} 