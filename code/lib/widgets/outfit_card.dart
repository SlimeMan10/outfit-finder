/// A card widget that displays an outfit's details.
/// This widget shows the outfit name, weather conditions, and clothing items
/// in a visually appealing card format.
import 'package:flutter/material.dart';
import 'package:outfit_finder/models/outfit.dart';
import 'package:outfit_finder/views/outfit_view.dart';
import 'package:outfit_finder/weather_conditions.dart';
import 'package:outfit_finder/helper/color_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final loc = AppLocalizations.of(context);
    if (loc == null) return const SizedBox.shrink(); // Return empty widget if localization is not available

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
                  child: Text(loc.edit, style: const TextStyle(fontSize: 16)),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(40, 30)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _buildWeatherTag(context),
            const SizedBox(height: 12),
            // Clothing items list
            FutureBuilder<List<dynamic>>(
              future: outfit.getClothingItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(loc.loadingItems);
                }
                if (snapshot.hasError) {
                  return Text('${loc.error}: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text(loc.noItemsInOutfit);
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: snapshot.data!
                      .map((item) => _clothingChip(context, item))
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

  Widget _buildWeatherTag(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) return const SizedBox.shrink();

    if (outfit.isForSunny) {
      return _weatherRow(Icons.wb_sunny, loc.sunny);
    } else if (outfit.isForRainy) {
      return _weatherRow(Icons.beach_access, loc.rainyDay);
    } else if (outfit.isForGloomy) {
      return _weatherRow(Icons.cloud, loc.cloudyDay);
    } else {
      return _weatherRow(Icons.help_outline, loc.any);
    }
  }

  Widget _weatherRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, semanticLabel: label),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  /// Creates a chip widget for a clothing item.
  /// 
  /// Parameters:
  /// - context: The build context
  /// - item: The clothing item to display
  /// Returns: A chip widget showing the item's description and color
  Widget _clothingChip(BuildContext context, dynamic item) {
    final colorHelper = ColorHelper();
    final color = colorHelper.getColorFromString(item.colorName);
    final loc = AppLocalizations.of(context);
    if (loc == null) return const SizedBox.shrink();

    String localizedDescription;
    switch (item.description) {
      case 'White T-shirt':
        localizedDescription = loc.whiteTShirt;
        break;
      case 'Blue Jeans':
        localizedDescription = loc.blueJeans;
        break;
      case 'Sunglasses':
        localizedDescription = loc.sunglasses;
        break;
      case 'Rain Jacket':
        localizedDescription = loc.rainJacket;
        break;
      case 'Waterproof Boots':
        localizedDescription = loc.waterproofBoots;
        break;
      case 'Umbrella':
        localizedDescription = loc.umbrella;
        break;
      default:
        localizedDescription = item.description;
    }
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
          Text(localizedDescription, style: const TextStyle(fontSize: 15)),
          const SizedBox(width: 6),
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade400, width: 1),
            ),
            child: Semantics(
              label: '${localizedDescription} color: ${item.colorName}',
              child: const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
