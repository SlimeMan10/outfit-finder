// Represents an outfit in the wardrobe system.
// This class manages a collection of clothing items and their weather suitability.
//
// The class is annotated with @collection to enable Isar database storage.
import 'clothing_item.dart';
import 'package:isar/isar.dart';
import 'package:outfit_finder/helper/isar_helper.dart';
//import 'package:outfit_finder/weather_conditions.dart';

part 'outfit.g.dart';

/// Unique identifier for the outfit in the database
@collection
class Outfit {
  Id id = Isar.autoIncrement;

  /// Name of the outfit (e.g., "Summer Casual", "Winter Formal")
  final String name;

  /// Indicates if the outfit is suitable for gloomy/overcast weather
  final bool isForGloomy;
  
  /// Indicates if the outfit is suitable for sunny weather
  final bool isForSunny;
  
  /// Indicates if the outfit is suitable for rainy weather
  final bool isForRainy;

  /// Collection of clothing items that make up this outfit
  final IsarLinks<ClothingItem> clothingItems = IsarLinks<ClothingItem>();

  /// Creates a new Outfit instance with specified weather conditions.
  /// 
  /// Parameters:
  /// - name: The name of the outfit (defaults to empty string)
  /// - isForGloomy: Whether the outfit is suitable for gloomy weather (defaults to false)
  /// - isForSunny: Whether the outfit is suitable for sunny weather (defaults to false)
  /// - isForRainy: Whether the outfit is suitable for rainy weather (defaults to false)
  Outfit({
    this.name = '',
    this.isForGloomy = false,
    this.isForSunny = false,
    this.isForRainy = false,
  });

  /// Adds a clothing item to this outfit and persists it to the database.
  /// 
  /// Parameters:
  /// - clothingItem: The clothing item to add to the outfit
  Future<void> addItem({required ClothingItem clothingItem}) async {
    await isar.writeTxn(() async {
      // Save the clothing item to database first
      await isar.collection<ClothingItem>().put(clothingItem);
      // Add to this outfit's items
      clothingItems.add(clothingItem);
      // Save the relationship
      await clothingItems.save();
    });
  }

  /// Removes a clothing item from this outfit.
  /// 
  /// Parameters:
  /// - itemToDelete: The clothing item to remove from the outfit
  /// Returns: true if the item was successfully removed
  Future<bool> deleteItem({required ClothingItem itemToDelete}) async {
    await isar.writeTxn(() async {
      clothingItems.remove(itemToDelete);
      await clothingItems.save();
    });
    return true;
  }

  /// Retrieves all clothing items in this outfit.
  /// 
  /// Returns: A list of all clothing items in the outfit
  Future<List<ClothingItem>> getClothingItems() async {
    await clothingItems.load();
    return clothingItems.toList();
  }

  /// Creates a sample outfit for testing purposes.
  /// The outfit consists of a white t-shirt, blue jeans, and white shoes,
  /// suitable for sunny weather.
  /// 
  /// Returns: A new Outfit instance with sample clothing items
  static Outfit createDummyOutfit() {
    final outfit = Outfit(
      name: 'Summer Casual',
      isForSunny: true,
    );

    final tshirt = ClothingItem(
      description: 'T-shirt',
      colorName: 'white',
    );

    final jeans = ClothingItem(
      description: 'Jeans',
      colorName: 'darkblue',
    );

    final shoes = ClothingItem(
      description: 'Shoes',
      colorName: 'white',
    );

    outfit.addItem(clothingItem: tshirt);
    outfit.addItem(clothingItem: jeans);
    outfit.addItem(clothingItem: shoes);

    return outfit;
  }
}
