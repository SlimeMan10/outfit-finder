import 'package:flutter/material.dart';
import 'package:outfit_finder/models/outfit.dart';
import 'package:outfit_finder/views/outfit_view.dart';
import 'package:outfit_finder/weather_conditions.dart';
import 'package:outfit_finder/helper/color_helper.dart';

// widget card to display each outfit
class OutfitCard extends StatelessWidget {
  // outfit to display
  final Outfit outfit;
  final WeatherCondition currentWeather;

  // constructs an OutfitCard with given outfit
  const OutfitCard(
      {super.key, required this.outfit, required this.currentWeather});

  // builds outfit card displaying
  // outfit name, weather tags, clothing items, and edit button
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
            FutureBuilder<List<dynamic>>(
              // dynamic for ClothingItem
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

  // Asynchronously navigates to given outfit view to edit and
  // navigates back to all outfits
  Future<void> _navigateToOutfit(BuildContext context, Outfit outfit) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => OutfitView(outfit: outfit)));
  }

  // makes row of weather tags for outfit
  Widget _makeWeatherRow() {
    List<Widget> weatherTags = [];
    if (outfit.isForSunny) {
      weatherTags.addAll([
        const Icon(Icons.wb_sunny, size: 18),
        const SizedBox(width: 4),
        const Text('Sunny', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 4),
      ]);
    }

    if (outfit.isForRainy) {
      weatherTags.addAll([
        const Icon(Icons.beach_access, size: 18),
        const SizedBox(width: 4),
        const Text('Rainy', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 4),
      ]);
    }

    if (outfit.isForRainy) {
      weatherTags.addAll([
        const Icon(Icons.cloud, size: 18),
        const SizedBox(width: 4),
        const Text('Gloomy', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 4),
      ]);
    }

    return Row ( children: weatherTags);
  }

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
