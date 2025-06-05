import 'package:outfit_finder/models/clothing_item.dart';
import 'package:outfit_finder/models/outfit.dart';
import 'package:flutter/material.dart';
import 'package:outfit_finder/helper/color_helper.dart';
import 'package:outfit_finder/providers/database_provider.dart';
import 'package:outfit_finder/widgets/clothing_item_widget.dart';
import 'package:provider/provider.dart';

// individual outfit view for editing or creating a new outfit
class OutfitView extends StatefulWidget {
  // outfit to edit/create
  final Outfit outfit;

  // constructs a OutfitView with given outfit and database provider
  const OutfitView({super.key, required this.outfit});

  @override
  State<OutfitView> createState() => _OutfitViewState();
}

// state of OutfitView
class _OutfitViewState extends State<OutfitView> {
  final _formKey = GlobalKey<FormState>();
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
      appBar: AppBar(
        title: const Text('Edit Outfit'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: currentOutfitNameText,
                decoration: const InputDecoration(
                  labelText: 'Outfit Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an outfit name';
                  }
                  return null;
                },
                onChanged: (value) => currentOutfitNameText = value,
              ),
              const SizedBox(height: 16),
              const Text('Weather Conditions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _displayWeatherIcons(),
              const SizedBox(height: 24),
              const Text('Add Clothing Item', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _createItemTile(),
              const SizedBox(height: 24),
              const Text('Current Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _displayClothingItems(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _doSave(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Save Outfit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Outfit'),
        content: const Text('Are you sure you want to delete this outfit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<DatabaseProvider>().deleteOutfit(widget.outfit);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  // saves edited Outfit to db from state weather bools and items
  void _doSave(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final newOutfit = Outfit(
      name: currentOutfitNameText,
      isForGloomy: isForGloomy,
      isForRainy: isForRainy,
      isForSunny: isForSunny,
    );

    // adds new items
    // does not add duplicate items?
    for (var item in clothingItems) {
      await newOutfit.addItem(clothingItem: item);
    }

    if (context.mounted) {
      await context.read<DatabaseProvider>().addOutfit(newOutfit);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  // displays weather icon buttons for weather condition tags of outfit
  // maintains local state of weather tags for outfit
  // does NOT update outfit's weather tags until back/create button clicked
  Widget _displayWeatherIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _makeWeatherButton('Rainy', isForRainy),
        _makeWeatherButton('Gloomy', isForGloomy),
        _makeWeatherButton('Sunny', isForSunny),
      ],
    );
  }

  // makes a weather button that when clicked
  // selects/deselects weather tag
  // does NOT change outfit's tags
  Widget _makeWeatherButton(String condition, bool isSelected) {
    IconData icon = switch (condition) {
      'Gloomy' => Icons.cloud,
      'Sunny' => Icons.wb_sunny,
      'Rainy' => Icons.water_drop,
      _ => Icons.question_mark
    };

    return ElevatedButton(
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
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Icon(icon),
    );
  }

  // displays outfit's clothing items in a rounded box
  Widget _displayClothingItems() {
    if (clothingItems.isEmpty) {
      return const Center(
        child: Text('No items added yet'),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        padding: const EdgeInsets.all(8),
        itemCount: clothingItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(clothingItems[index].description),
            onDismissed: (direction) {
              setState(() {
                clothingItems.removeAt(index);
              });
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: ClothingItemWidget(item: clothingItems[index]),
          );
        },
      ),
    );
  }

  // creates tile for creating a new clothing item
  // gets the item description and color
  Widget _createItemTile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Item Description',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an item description';
              }
              return null;
            },
            onChanged: (value) => currentItemText = value,
          ),
          const SizedBox(height: 16),
          const Text('Select Color', style: TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          _buildPalette(),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  addItem();
                  setState(() {
                    currentItemText = '';
                  });
                }
              },
              child: const Text('Add Item'),
            ),
          ),
        ],
      ),
    );
  }

  // adds new item from current description and color to items
  void addItem() {
    final colorName = ColorHelper().getStringFromColor(currentItemColor);
    final itemToAdd = ClothingItem(
      description: currentItemText,
      colorName: colorName,
    );
    setState(() {
      clothingItems.add(itemToAdd);
    });
  }

  // builds 8x2 grid of color buttons to select for new clothing item
  Widget _buildPalette() {
    // getting predefined set of colors for items
    final colors = ColorHelper().colorMap.values.toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        childAspectRatio: 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final color = colors[index];
        return _buildColorButton(color);
      },
    );
  }

  // builds a circular color button to select item color
  // Params:
  //  -color: color to create button for
  Widget _buildColorButton(Color color) {
    final isSelected = color == currentItemColor;
    return GestureDetector(
      onTap: () => setState(() => currentItemColor = color),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
