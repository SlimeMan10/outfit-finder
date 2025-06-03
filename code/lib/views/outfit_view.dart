import 'package:outfit_finder/models/clothing_item.dart';
import 'package:outfit_finder/models/outfit.dart';
import 'package:flutter/material.dart';
import 'package:outfit_finder/helper/color_helper.dart';
import 'package:outfit_finder/providers/database_provider.dart';

// individual outfit view for editing or creating a new outfit
class OutfitView extends StatefulWidget {
  // outfit to edit/create
  final Outfit outfit;

  // database provider managing outfits and clothing items
  final DatabaseProvider databaseProvider;

  // constructs a OutfitView with given outfit and database provider
  const OutfitView(
      {super.key, required this.outfit, required this.databaseProvider});

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

  // initializes outfit view state
  @override
  void initState() {
    super.initState();
    currentOutfitNameText = widget.outfit.name;
  }

  // builds the outfit view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [_createItemTile()],
    ));
  }

  // creates tile for creating a new clothing item
  // gets the item description and color
  Widget _createItemTile() {
    return Container(
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

  // creates and adds item to outfit with current description and color
  void addItem() {
    final colorName = ColorHelper().getStringFromColor(currentItemColor);
    final itemToAdd =
        ClothingItem(description: currentItemText, colorName: colorName);
    widget.databaseProvider.addItemToOutfit(widget.outfit, itemToAdd);
  }

  // builds 8x2 grid of color buttons to select for new clothing item
  Widget _buildPalette() {
    // getting predefined set of colors for items
    final colors = ColorHelper().colorMap.values.toList();
    final colorButtons =
        colors.map((color) => _buildColorButton(color)).toList();
    return Column(
      children: [
        Row(children: colorButtons.sublist(0, 7)),
        Row(children: colorButtons.sublist(8, 15))
      ],
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
