/// A view for editing or creating outfits.
/// This widget provides a form interface for managing outfit details,
/// including name, weather conditions, and clothing items.
import 'package:outfit_finder/models/clothing_item.dart';
import 'package:outfit_finder/models/outfit.dart';
import 'package:flutter/material.dart';
import 'package:outfit_finder/helper/color_helper.dart';
import 'package:outfit_finder/providers/database_provider.dart';
import 'package:outfit_finder/widgets/clothing_item_widget.dart';
import 'package:provider/provider.dart';

/// Widget for editing or creating an outfit.
class OutfitView extends StatefulWidget {
  /// The outfit to be edited or used as a template for creation
  final Outfit outfit;

  /// Creates a new OutfitView instance.
  /// 
  /// Parameters:
  /// - outfit: The outfit to edit or use as a template
  const OutfitView({super.key, required this.outfit});

  @override
  State<OutfitView> createState() => _OutfitViewState();
}

/// State class for the OutfitView widget.
/// Manages the form state and outfit editing functionality.
class _OutfitViewState extends State<OutfitView> {
  /// Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  /// Current text input for new clothing item description
  String currentItemText = '';

  /// Current name of the outfit being edited
  String currentOutfitNameText = '';

  /// Currently selected color for new clothing item
  Color currentItemColor = Colors.white;

  /// List of clothing items in the outfit
  List<ClothingItem> clothingItems = [];

  /// Flag indicating if outfit is suitable for rainy weather
  bool isForRainy = false;

  /// Flag indicating if outfit is suitable for gloomy weather
  bool isForGloomy = false;

  /// Flag indicating if outfit is suitable for sunny weather
  bool isForSunny = false;

  /// Initializes the outfit view state with values from the provided outfit
  @override
  void initState() {
    super.initState();
    currentOutfitNameText = widget.outfit.name;
    clothingItems = widget.outfit.clothingItems.toList();
    isForGloomy = widget.outfit.isForGloomy;
    isForRainy = widget.outfit.isForRainy;
    isForSunny = widget.outfit.isForSunny;
  }

  /// Builds the outfit editing interface
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Outfit'),
        leading: Semantics(
          label: 'Back',
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Semantics(
            label: 'Delete outfit',
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteConfirmation(context),
            ),
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
              // Outfit name input field
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
              
              // Weather conditions section
              const Row(
                children: [
                  Icon(Icons.wb_sunny, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Weather Conditions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              _displayWeatherIcons(),
              const SizedBox(height: 24),
              
              // Add clothing item section
              const Row(
                children: [
                  Icon(Icons.add_circle_outline, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Add Clothing Item', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              _createItemTile(),
              const SizedBox(height: 24),
              
              // Current items section
              const Row(
                children: [
                  Icon(Icons.checkroom, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Current Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              _displayClothingItems(),
              const SizedBox(height: 24),
              
              // Save button
              SizedBox(
                width: double.infinity,
                child: Semantics(
                  label: 'Save outfit',
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Save Outfit'),
                    onPressed: () => _doSave(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows a confirmation dialog before deleting the outfit
  /// 
  /// Parameters:
  /// - context: The build context
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

  /// Saves the edited outfit to the database
  /// 
  /// Parameters:
  /// - context: The build context
  void _doSave(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final newOutfit = Outfit(
      name: currentOutfitNameText,
      isForGloomy: isForGloomy,
      isForRainy: isForRainy,
      isForSunny: isForSunny,
    );

    // Add all clothing items to the new outfit
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

  /// Displays weather condition selection buttons
  /// 
  /// Returns: A row of weather condition buttons
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

  /// Creates a weather condition selection button
  /// 
  /// Parameters:
  /// - condition: The weather condition this button represents
  /// - isSelected: Whether this condition is currently selected
  /// Returns: A button widget for selecting a weather condition
  Widget _makeWeatherButton(String condition, bool isSelected) {
    IconData icon = switch (condition) {
      'Gloomy' => Icons.cloud,
      'Sunny' => Icons.wb_sunny,
      'Rainy' => Icons.water_drop,
      _ => Icons.question_mark
    };
    Color selectedColor = switch (condition) {
      'Gloomy' => Colors.grey,
      'Sunny' => Colors.orange,
      'Rainy' => Colors.blue,
      _ => Colors.black
    };
    return Semantics(
      label: '$condition weather button, ${isSelected ? "selected" : "not selected"}',
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withValues(alpha: .15) : Colors.transparent,
          border: Border.all(
            color: isSelected ? selectedColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: Icon(icon, color: isSelected ? selectedColor : Colors.grey),
          onPressed: () {
            setState(() {
              if (condition == 'Rainy') isForRainy = !isForRainy;
              if (condition == 'Gloomy') isForGloomy = !isForGloomy;
              if (condition == 'Sunny') isForSunny = !isForSunny;
            });
          },
        ),
      ),
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
        borderRadius: BorderRadius.circular(12),
        color: Colors.blueGrey[50],
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
          final item = clothingItems[index];
          return Semantics(
            label: 'Clothing item: ${item.description}, color: ${item.colorName}',
            child: Dismissible(
              key: Key(item.description),
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
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClothingItemWidget(item: item),
                ),
              ),
            ),
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
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green),
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
          const Row(
            children: [
              Icon(Icons.palette, color: Colors.purple),
              SizedBox(width: 8),
              Text('Select Color', style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          _buildPalette(),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Semantics(
              label: 'Add clothing item',
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addItem();
                    setState(() {
                      currentItemText = '';
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
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
    return Semantics(
      label: 'Color button, ${ColorHelper().getStringFromColor(color)}${isSelected ? ", selected" : ""}',
      child: GestureDetector(
        onTap: () => setState(() => currentItemColor = color),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Colors.black : Colors.transparent,
              width: 2,
            ),
            boxShadow: isSelected
                ? [const BoxShadow(color: Colors.black26, blurRadius: 4, spreadRadius: 1)]
                : [],
          ),
          width: 32,
          height: 32,
        ),
      ),
    );
  }
}
