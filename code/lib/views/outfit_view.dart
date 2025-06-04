import 'package:outfit_finder/models/clothing_item.dart';
import 'package:outfit_finder/models/outfit.dart';
import 'package:flutter/material.dart';
import 'package:outfit_finder/helper/color_helper.dart';
import 'package:outfit_finder/providers/database_provider.dart';
import 'package:outfit_finder/widgets/clothing_item_widget.dart';

// individual outfit view for editing or creating a new outfit
class OutfitView extends StatefulWidget {
  // outfit to edit/create
  final Outfit outfit;

  // database provider managing outfits and clothing items
  //final DatabaseProvider databaseProvider;

  // constructs a OutfitView with given outfit and database provider
  const OutfitView(
      {super.key, required this.outfit});

  @override
  State<OutfitView> createState() => _OutfitViewState();
}

// state of OutfitView
class _OutfitViewState extends State<OutfitView> {
  // Entered item description
  String currentItemText = '';

  // name of current outfit
  String currentOutfitNameText = '';

  // selected color for color item creation
  Color currentItemColor = Colors.white;

  // clothing items of outfit
  List<ClothingItem> clothingItems = [];

  // whether outfit is for rainy whether
  bool isForRainy = false;

  // whether outfit is for rainy whether
  bool isForGloomy = false;

  // whether outfit is for rainy whether
  bool isForSunny = false;

  // initializes outfit view state
  @override
  void initState() {
    super.initState();
    currentOutfitNameText = widget.outfit.name;
    clothingItems = widget.outfit.clothingItems.toList();
    isForGloomy = widget.outfit.isForGloomy;
    isForRainy = widget.outfit.isForRainy;
    isForSunny = widget.outfit.isForSunny;
  }

  // builds the outfit view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        _displayWeatherIcons(),
        _createItemTile(),
        const Text('Clothing Items'),
        _displayClothingItems(),
        _makeSaveButton(context)
      ],
    ));
  }

  Widget _makeSaveButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () => _doSave(context), child: const Text('Save'));
  }

  void _doSave(BuildContext context) {
    // TODO: save edited Outfit to db from state weather bools and items 
    
  }

  // displays weather icon buttons for weather condition tags of outfit
  // maintains local state of weather tags for outfit
  // does NOT update outfit's weather tags until back/create button clicked
  Widget _displayWeatherIcons() {
    return Row(
      children: [
        _makeWeatherButton('Rainy', isForRainy),
        _makeWeatherButton('Gloomy', isForGloomy),
        _makeWeatherButton('Sunny', isForSunny)
      ],
    );
  }

  // makes a weather button that when clicked
  // selects/deselects weather tag
  // does NOT change outfit's tags
  Widget _makeWeatherButton(String condition, bool isSelected) {
    Icon icon = switch (condition) {
      'Gloomy' => const Icon(Icons.cloud),
      'Sunny' => const Icon(Icons.sunny),
      'Rainy' => const Icon(Icons.water_drop),
      _ => const Icon(Icons.question_mark)
    };

    return OutlinedButton(
      onPressed: () => setState(() {
        switch (condition) {
          case 'Gloomy':
            isForGloomy = !isForGloomy;
            break;
          case 'Sunny':
            isForSunny = !isForSunny;
            break;
          case 'Rainy':
            isForRainy = !isForRainy;
            break;
        }
      }),
      style: (isSelected)
          ? OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black))
          : OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white)),
      child: icon,
    );
  }

  // displays outfit's clothing items in a rounded box
  Widget _displayClothingItems() {
    final clothingItemWidgets =
        clothingItems.map((item) => ClothingItemWidget(item: item)).toList();

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: Colors.grey)),
        child: GridView.count(
          crossAxisCount: 2,
          children: clothingItemWidgets,
        ));
  }

  // creates tile for creating a new clothing item
  // gets the item description and color
  Widget _createItemTile() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(2)),
      child: Column(
        children: [
          TextFormField(
            initialValue: 'Enter Item',
            onChanged: (newItemText) => currentItemText = newItemText,
          ),
          ElevatedButton(
              onPressed: () => addItem(), child: const Text('Add Item')),
          _buildPalette()
        ],
      ),
    );
  }

  // adds new item from current description and color to items 
  void addItem() {
    final colorName = ColorHelper().getStringFromColor(currentItemColor);
    final itemToAdd =
        ClothingItem(description: currentItemText, colorName: colorName);

    clothingItems.add(itemToAdd);
    //widget.databaseProvider.addItemToOutfit(widget.outfit, itemToAdd);
  }

  // builds 8x2 grid of color buttons to select for new clothing item
  Widget _buildPalette() {
    // getting predefined set of colors for items
    final colors = ColorHelper().colorMap.values.toList();
    final colorButtons =
        colors.map((color) => _buildColorButton(color)).toList();
    return GridView.count(
      crossAxisCount: 8,
      children: colorButtons,
    );
  }

  // builds a circular color button to select item color
  // Params:
  //  -color: color to create button for
  Widget _buildColorButton(Color color) {
    return ElevatedButton(
        onPressed: () => currentItemColor = color,
        child: null,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(50, 50),
          shape: const CircleBorder(), // makes button circular
          backgroundColor: color,
        ));
  }
}
