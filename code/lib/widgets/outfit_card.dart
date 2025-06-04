import 'package:flutter/material.dart';
import 'package:outfit_finder/models/outfit.dart';
import 'package:outfit_finder/widgets/clothing_item_widget.dart';
import 'package:outfit_finder/views/outfit_view.dart';

// widget card to display each outfit
class OutfitCard extends StatelessWidget {
  // outfit to display
  final Outfit outfit;

  // constructs an OutfitCard with given outfit
  const OutfitCard({super.key, required this.outfit});

  // builds outfit card displaying
  // outfit name, weather tags, clothing items, and edit button
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(outfit.name),
      subtitle: Column(
        children: [
          _displayWeatherTags(),
          _displayClothingItems(),
        ],
      ),
      leading: TextButton(
          onPressed: () => _navigateToOutfit(context, outfit),
          child: const Text('Edit')),
    );
  }

  // Asynchronously navigates to given outfit view to edit and
  // navigates back to all outfits
  Future<void> _navigateToOutfit(BuildContext context, Outfit outfit) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => OutfitView(outfit: outfit)));
  }

  // displays outfit's weather tags
  Widget _displayWeatherTags() {
    return Row(
      children: [
        if (outfit.isForRainy) ...[
          const Icon(Icons.sunny),
          const Text('Sunny')
        ],
        if (outfit.isForGloomy) ...[
          const Icon(Icons.cloud),
          const Text('Cloudy')
        ],
        if (outfit.isForSunny) ...[const Icon(Icons.sunny), const Text('Sunny')]
      ],
    );
  }

  // displays outfit's clothing items in a rounded box
  Widget _displayClothingItems() {
    final clothingItemWidgets = outfit.clothingItems
        .map((item) => ClothingItemWidget(item: item))
        .toList();

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: Colors.grey)),
        child: GridView.count(
          crossAxisCount: 2, // 2 items per row
          children: clothingItemWidgets,
        ));
  }
}
