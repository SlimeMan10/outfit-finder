import 'clothing_item.dart';
import 'package:isar/isar.dart';
import 'package:outfit_finder/helper/isar_helper.dart';
//import 'package:outfit_finder/weather_conditions.dart';

part 'outfit.g.dart';

// represents an inputted outfit in wardrobe
@collection
class Outfit {
  // id of unique outfit entry in wardrobe
  Id id = Isar.autoIncrement;

  /// name of the outfit
  final String name;

  // whether outfit is wearable for gloomy weather
  final bool isForGloomy;
  // whether outfit is wearable for sunny weather
  final bool isForSunny;
  // whether outfit is wearable for rainy weather
  final bool isForRainy;

  // clothing items comprising outfit
  final IsarLinks<ClothingItem> clothingItems = IsarLinks<ClothingItem>();

  /// Constructs Outfit with optional named params if given
  /// (all bools default to false)
  /// Parameters:
  ///   - id: unique outfit entry id, increments automatically by 1
  ///   - isForGloomy: whether outfit is for gloomy weather
  ///   - isForSunny: whether outfit is for sunny weather
  ///   - isForRainy: whether outfit is for rainy weather
  Outfit({
    this.name = '',
    this.isForGloomy = false,
    this.isForSunny = false,
    this.isForRainy = false,
  });

  /// Adds given clothing item to outfit
  /// (does not enforce uniqueness of items)
  /// Parameters:
  ///   - clothingItem: The clothing item to add
  ///   - isar: The Isar database instance
  Future<void> addItem(
      {required ClothingItem clothingItem}) async {
    await isar.writeTxn(() async {
      // Save the clothing item to database first
      await isar.collection<ClothingItem>().put(clothingItem);
      // Add to this outfit's items
      clothingItems.add(clothingItem);
      // Save the relationship
      await clothingItems.save();
    });
  }

  /// Deletes given clothing item if in outfit
  /// Parameters:
  ///   - itemToDelete: The clothing item to delete
  ///   - isar: The Isar database instance
  /// Returns: whether item was deleted
  Future<bool> deleteItem(
      {required ClothingItem itemToDelete}) async {
    await isar.writeTxn(() async {
      clothingItems.remove(itemToDelete);
      await clothingItems.save();
    });

    /// we might need to check if it was deleted
    return true;
  }

  /// Gets a shallow copy of clothing items
  /// Returns: List of clothing items in this outfit
  Future<List<ClothingItem>> getClothingItems() async {
    await clothingItems.load();
    return clothingItems.toList();
  }

  /// Creates a dummy outfit with a white t-shirt, blue jeans, and white shoes
  /// suitable for sunny weather
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
