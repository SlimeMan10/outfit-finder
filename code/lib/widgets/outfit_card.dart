/// A card widget that displays an outfit's details.
/// This widget shows the outfit name, weather conditions, and clothing items
/// in a visually appealing card format.
import 'package:flutter/material.dart';
import 'package:outfit_finder/models/outfit.dart';
import 'package:outfit_finder/views/outfit_view.dart';
import 'package:outfit_finder/weather_conditions.dart';
import 'package:outfit_finder/helper/color_helper.dart';

/// A card widget that displays an outfit's information.
class OutfitCard extends StatelessWidget {
  /// The outfit to display in the card
  final Outfit outfit;
  
  /// The current weather condition
  final WeatherCondition currentWeather;

  /// Creates a new OutfitCard instance.
  /// 
  /// Parameters:
  /// - outfit: The outfit to display
  /// - currentWeather: The current weather condition
  const OutfitCard({
    super.key, 
    required this.outfit, 
    required this.currentWeather
  });

  /// Builds the outfit card with name, weather tags, and clothing items.
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Outfit name and edit button row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    outfit.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () => _navigateToOutfit(context, outfit),
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(40, 30)),
                  child: const Text('Edit', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _makeWeatherRow(),
            const SizedBox(height: 12),
            // Clothing items list
            FutureBuilder<List<dynamic>>(
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
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: snapshot.data!
                      .map((item) => _clothingChip(item))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Navigates to the outfit editing view.
  /// 
  /// Parameters:
  /// - context: The build context
  /// - outfit: The outfit to edit
  Future<void> _navigateToOutfit(BuildContext context, Outfit outfit) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => OutfitView(outfit: outfit)));
  }

  /// Creates a row of weather condition tags for the outfit.
  /// 
  /// Returns: A row containing icons and labels for each applicable weather condition
  Widget _makeWeatherRow() {
    List<Widget> weatherTags = [];
    
    // Add sunny weather tag if applicable
    if (outfit.isForSunny) {
      weatherTags.addAll([
        const Icon(Icons.wb_sunny, size: 18),
        const SizedBox(width: 4),
        const Text('Sunny', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 4),
      ]);
    }

    // Add rainy weather tag if applicable
    if (outfit.isForRainy) {
      weatherTags.addAll([
        const Icon(Icons.beach_access, size: 18),
        const SizedBox(width: 4),
        const Text('Rainy', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 4),
      ]);
    }

    // Add gloomy weather tag if applicable
    if (outfit.isForRainy) {
      weatherTags.addAll([
        const Icon(Icons.cloud, size: 18),
        const SizedBox(width: 4),
        const Text('Gloomy', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 4),
      ]);
    }

    return Row(children: weatherTags);
  }

  /// Creates a chip widget for a clothing item.
  /// 
  /// Parameters:
  /// - item: The clothing item to display
  /// Returns: A chip widget showing the item's description and color
  Widget _clothingChip(dynamic item) {
    final colorHelper = ColorHelper();
    final color = colorHelper.getColorFromString(item.colorName);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(item.description, style: const TextStyle(fontSize: 15)),
          const SizedBox(width: 6),
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade400, width: 1),
            ),
          ),
        ],
      ),
    );
  }
}
