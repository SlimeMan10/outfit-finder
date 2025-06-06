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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Widget for editing or creating an outfit.
class OutfitView extends StatefulWidget {
  /// The outfit to be edited or used as a template for creation
  final Outfit outfit;

  /// Callback to trigger a refresh in the parent view
  final VoidCallback? onRefresh;

  /// Creates a new OutfitView instance.
  /// 
  /// Parameters:
  /// - outfit: The outfit to edit or use as a template
  /// - onRefresh: Callback to refresh parent after save/delete
  const OutfitView({super.key, required this.outfit, this.onRefresh});

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

  /// Undo/redo stacks for clothing items
  final List<ClothingItem> _undoStack = [];
  final List<ClothingItem> _redoStack = [];

  /// Flag indicating if outfit is suitable for rainy weather
  bool isForRainy = false;

  /// Flag indicating if outfit is suitable for gloomy weather
  bool isForGloomy = false;

  /// Flag indicating if outfit is suitable for sunny weather
  bool isForSunny = false;

  /// Flag indicating if outfit is suitable for the second sunny icon
  bool isForSunny2 = false;

  /// Text controller for the item input field
  final TextEditingController _itemController = TextEditingController();

  /// Text controller for the outfit name field
  final TextEditingController _nameController = TextEditingController();

  /// Initializes the outfit view state with values from the provided outfit
  @override
  void initState() {
    super.initState();
    currentOutfitNameText = widget.outfit.name;
    _nameController.text = currentOutfitNameText;
    clothingItems = widget.outfit.clothingItems.toList();
    isForGloomy = widget.outfit.isForGloomy;
    isForRainy = widget.outfit.isForRainy;
    isForSunny = widget.outfit.isForSunny;
    isForSunny2 = false; // Default to false, as Outfit model does not have this
  }

  @override
  void dispose() {
    _itemController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  /// Builds the outfit editing interface
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) return const SizedBox.shrink();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Semantics(
          label: loc.backToWardrobe,
          button: true,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              semanticLabel: loc.backToWardrobe,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: loc.backToWardrobe,
          ),
        ),
        actions: [
          Semantics(
            label: loc.undo,
            button: true,
            child: IconButton(
              icon: Icon(
                Icons.undo,
                semanticLabel: loc.undo,
              ),
              onPressed: clothingItems.isNotEmpty
                  ? () {
                      setState(() {
                        final removed = clothingItems.removeLast();
                        _undoStack.add(removed);
                      });
                    }
                  : null,
              tooltip: loc.undo,
            ),
          ),
          Semantics(
            label: loc.redo,
            button: true,
            child: IconButton(
              icon: Icon(
                Icons.redo,
                semanticLabel: loc.redo,
              ),
              onPressed: _undoStack.isNotEmpty
                  ? () {
                      setState(() {
                        final restored = _undoStack.removeLast();
                        clothingItems.add(restored);
                      });
                    }
                  : null,
              tooltip: loc.redo,
            ),
          ),
          if (widget.outfit.name.isNotEmpty) // Only show delete for existing outfits
            Semantics(
              label: loc.deleteOutfit,
              button: true,
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.black,
                  semanticLabel: loc.deleteOutfit,
                ),
                onPressed: () => _showDeleteConfirmation(context),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Outfit title with editable text field
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: loc.outfitNameLabel,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      onChanged: (value) {
                        setState(() {
                          currentOutfitNameText = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Weather conditions section
              _displayWeatherIcons(),
              const SizedBox(height: 32),
              
              // Clothing Items section
              Text(
                loc.currentItems,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              _displayClothingItems(),
              const SizedBox(height: 24),
              
              // Enter Item section
              _createItemTile(),
              const SizedBox(height: 32),
              
              // Create Outfit button
              Center(
                child: SizedBox(
                  width: 200,
                  child: Semantics(
                    label: loc.saveOutfit,
                    button: true,
                    child: ElevatedButton(
                      onPressed: () => _doSave(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        loc.saveOutfit,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
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
        if (widget.onRefresh != null) widget.onRefresh!();
      }
    }
  }

  /// Saves the edited outfit to the database
  /// 
  /// Parameters:
  /// - context: The build context
  void _doSave(BuildContext context) async {
    if (currentOutfitNameText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an outfit name')),
      );
      return;
    }

    try {
      // 1. Save the Outfit first (so it gets an ID)
      final dbProvider = context.read<DatabaseProvider>();
      final newOutfit = Outfit(
        name: currentOutfitNameText,
        isForGloomy: isForGloomy,
        isForRainy: isForRainy,
        isForSunny: isForSunny,
      );
      await dbProvider.addOutfit(newOutfit);

      // 2. Reload the managed Outfit from Isar
      final managedOutfit = await dbProvider.getOutfitByNameAndFlags(
        currentOutfitNameText, isForGloomy, isForRainy, isForSunny);
      if (managedOutfit == null) {
        throw Exception('Failed to reload saved outfit from database.');
      }

      // 3. Add all clothing items to the managed outfit (persist links)
      for (var item in clothingItems) {
        await dbProvider.addItemToOutfit(managedOutfit, item);
      }

      // 4. Reload data and pop back to all outfits view
      await dbProvider.loadData();
      if (context.mounted) {
        Navigator.pop(context);
        if (widget.onRefresh != null) widget.onRefresh!();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save outfit: $e')),
        );
      }
    }
  }

  /// Displays weather condition selection buttons
  /// 
  /// Returns: A row of weather condition buttons
  Widget _displayWeatherIcons() {
    final loc = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc?.weatherConditions ?? 'Weather Conditions',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildWeatherIcon(
              Icons.wb_sunny,
              isForSunny,
              loc?.sunny ?? 'Sunny',
              () => setState(() => isForSunny = !isForSunny),
            ),
            const SizedBox(width: 16),
            _buildWeatherIcon(
              Icons.cloud,
              isForGloomy,
              loc?.cloudyDay ?? 'Cloudy',
              () => setState(() => isForGloomy = !isForGloomy),
            ),
            const SizedBox(width: 16),
            _buildWeatherIcon(
              Icons.beach_access,
              isForRainy,
              loc?.rainyDay ?? 'Rainy',
              () => setState(() => isForRainy = !isForRainy),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherIcon(IconData icon, bool isSelected, String label, VoidCallback onTap) {
    return Semantics(
      label: label,
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey[200] : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 32,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  /// Displays outfit's clothing items in a rounded container
  Widget _displayClothingItems() {
    final loc = AppLocalizations.of(context);
    if (clothingItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Semantics(
            label: loc?.noItemsInOutfit,
            child: Text(
              loc?.noItemsInOutfit ?? 'No items in this outfit',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: clothingItems.map((item) {
        return _buildClothingItem(item);
      }).toList(),
    );
  }

  /// Builds a clothing item chip
  Widget _buildClothingItem(ClothingItem item) {
    final color = ColorHelper().getColorFromString(item.colorName, context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.description,
              style: TextStyle(
                color: _getTextColorForBackground(color),
                fontSize: 16,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: _getTextColorForBackground(color),
            ),
            onPressed: () {
              setState(() {
                clothingItems.remove(item);
                _undoStack.add(item);
              });
            },
          ),
        ],
      ),
    );
  }

  /// Creates tile for creating a new clothing item
  Widget _createItemTile() {
    final loc = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Semantics(
            label: loc?.addClothingItem,
            button: true,
            child: TextField(
              controller: _itemController,
              decoration: InputDecoration(
                hintText: loc?.itemDescription,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(12),
              ),
              onChanged: (value) => currentItemText = value,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  addItem();
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildPalette(),
        ],
      ),
    );
  }

  /// Adds new item from current description and color to items
  void addItem() {
    if (currentItemText.isEmpty) return;
    
    final colorName = ColorHelper().getStringFromColor(currentItemColor, context);
    final itemToAdd = ClothingItem(
      description: currentItemText,
      colorName: colorName,
    );
    setState(() {
      clothingItems.add(itemToAdd);
      currentItemText = '';
      _itemController.clear();
      _undoStack.clear(); // Clear redo stack on new action
    });
  }

  /// Gets appropriate text color based on background color
  Color _getTextColorForBackground(Color backgroundColor) {
    // Calculate relative luminance
    final luminance = (0.299 * backgroundColor.red + 0.587 * backgroundColor.green + 0.114 * backgroundColor.blue) / 255;
    // Use white text for dark backgrounds, black text for light backgrounds
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  Widget _buildColorButton(Color color) {
    final isSelected = color == currentItemColor;
    return Semantics(
      label: 'Color button, ${ColorHelper().getStringFromColor(color, context)}${isSelected ? ", selected" : ""}',
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentItemColor = color;
          });
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Colors.black : Colors.transparent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPalette() {
    final colorHelper = ColorHelper();
    final colors = [
      colorHelper.black,
      colorHelper.darkGrey,
      colorHelper.lightGrey,
      colorHelper.white,
      colorHelper.darkBrown,
      colorHelper.lightBrown,
      colorHelper.darkBlue,
      colorHelper.lightBlue,
      colorHelper.darkGreen,
      colorHelper.lightGreen,
      colorHelper.red,
      colorHelper.blue,
      colorHelper.green,
      colorHelper.yellow,
      colorHelper.orange,
      colorHelper.purple,
      colorHelper.pink,
      colorHelper.brown,
      colorHelper.teal,
      colorHelper.navy,
      colorHelper.maroon,
      colorHelper.olive,
      colorHelper.lime,
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final color = colors[index];
        return _buildColorButton(color);
      },
    );
  }
}