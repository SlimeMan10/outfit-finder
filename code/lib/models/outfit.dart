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
  final List<ClothingItem> _clothingItems;

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
      clothingItems = const []})
      : _clothingItems = clothingItems;

  // adds given clothing item to outfit
  // (does not enforce uniqueness of items)
  void addItem({required clothingItem}) => _clothingItems.add(clothingItem);

  // Deletes given clothing item if in outfit
  // Returns whether item was deleted
  bool deleteItem({required itemToDelete}) =>
      _clothingItems.remove(itemToDelete);

  // gets a shallow copy of clothing items
  List<ClothingItem> get clothingItems => List.from(_clothingItems);
}
