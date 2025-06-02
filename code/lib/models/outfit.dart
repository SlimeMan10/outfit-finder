import 'clothing_item.dart';
import 'package:isar/isar.dart';
//import 'package:outfit_finder/weather_conditions.dart';

// represents an inputted outfit in wardrobe
@collection
class Outfit {
  // id of unique outfit entry in wardrobe
  Id? id;

  // could do Map of weather condition to boolean
  // or list of wearable weather conditions instead

  // whether outfit is wearable for gloomy weather
  final bool isForGloomy;
  // whether outfit is wearable for sunny weather
  final bool isForSunny;
  // whether outfit is wearable for rainy weather
  final bool isForRainy;

  // clothing items comprising outfit
  final IsarLinks<ClothingItem> clothingItems = IsarLinks<ClothingItem>();

  // Constructs Outfit with optional named params if given
  // (all bools default to false)
  // Params:
  //  id: unique outfit entry id, increments automatically by 1
  //  isForGloomy: whether outfit is for gloomy weather
  //  isForSunny: whether outfit is for sunny weather
  //  isForRainy: whether outfit is for rainy weather
  //  clothingItems: clothing items comprising outfit, defaults to empty list
  Outfit(
      {this.id,
      this.isForGloomy = false,
      this.isForSunny = false,
      this.isForRainy = false,

  // adds given clothing item to outfit
  // (does not enforce uniqueness of items)
    Future<void> addItem({required ClothingItem clothingItem, required Isar isar}) async {
    await isar.writeTxn(() async {
      // Save the clothing item to database first
      await isar.clothingItems.put(clothingItem);
      // Add to this outfit's items
      clothingItems.add(clothingItem);
      // Save the relationship
      await clothingItems.save();
    });
  }

  // Deletes given clothing item if in outfit
  // Returns whether item was deleted
  Future<bool> deleteItem({required ClothingItem itemToDelete, required Isar isar}) async {
    await isar.writeTxn(() async {
      clothingItems.remove(itemToDelete);
      await clothingItems.save();
    });
    /// we might need to check if it was deleted
    return true;
  }

  // gets a shallow copy of clothing items
  Future<List<ClothingItem>> getClothingItems() async {
    await clothingItems.load();
    return clothingItems.toList();
  }
}
