import 'package:flutter/material.dart';
import 'package:outfit_finder/models/outfit.dart';
import 'package:outfit_finder/models/clothing_item.dart';
import 'package:outfit_finder/weather_conditions.dart';
import 'package:provider/provider.dart';
import 'package:outfit_finder/providers/weather_provider.dart';
import 'package:outfit_finder/widgets/outfit_card.dart';

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
  WeatherCondition _selectedCondition = WeatherCondition.unknown;

  @override
  Widget build(BuildContext context) {
    final currentWeather = context.watch<WeatherProvider>().condition;
    return Expanded(
      child: _buildOutfitsList(),
    );
  }

  /// Builds the weather condition selector dropdown
  Widget _buildWeatherSelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButton<WeatherCondition>(
        value: _selectedCondition,
        hint: const Text('Select Weather Condition'),
        isExpanded: true,
        items: _buildWeatherDropdownItems(),
        onChanged: _handleWeatherSelection,
      ),
    );
  }

  /// Builds the dropdown items for weather conditions
  List<DropdownMenuItem<WeatherCondition>> _buildWeatherDropdownItems() {
    return WeatherCondition.values.map((condition) {
      return DropdownMenuItem(
        value: condition,
        child: Text(condition.toString()),
      );
    }).toList();
  }

  /// Handles weather condition selection
  void _handleWeatherSelection(WeatherCondition? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedCondition = newValue;
      });
    }
  }

  /// Builds the current weather suggestion button
  Widget _buildCurrentWeatherButton(WeatherCondition currentWeather) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextButton(
        onPressed: () {
          setState(() {
            _selectedCondition = currentWeather;
          });
        },
        child: Text('Use Current Weather: ${currentWeather.toString()}'),
      ),
    );
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

  /// Builds the list of items in an outfit
  Widget _buildOutfitItemsList(Outfit outfit) {
    return FutureBuilder<List<ClothingItem>>(
      future: outfit.getClothingItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading items...');
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No items in this outfit');
        }
        return Text(snapshot.data!.map((item) => item.description).join(', '));
      },
    );
  }
} 