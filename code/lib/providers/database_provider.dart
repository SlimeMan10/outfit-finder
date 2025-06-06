// Manages the application's database operations for outfits and clothing items.
// This provider handles CRUD operations for outfits and clothing items using Isar database.
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:outfit_finder/helper/isar_helper.dart';
import 'package:outfit_finder/models/outfit.dart';
import 'package:outfit_finder/models/clothing_item.dart';

class DatabaseProvider extends ChangeNotifier {
  /// Internal list of outfits stored in memory
  List<Outfit> _outfits = [];
  
  /// Internal list of clothing items stored in memory
  List<ClothingItem> _clothingItems = [];

  /// Getter for the list of outfits
  List<Outfit> get outfits => _outfits;
  
  /// Getter for the list of clothing items
  List<ClothingItem> get clothingItems => _clothingItems;

  /// Loads all outfits from the database into memory
  Future<void> _loadOutfits() async {
    _outfits = await isar.outfits.where().findAll();
  }

  /// Loads all clothing items from the database into memory
  Future<void> _loadClothingItems() async {
    _clothingItems = await isar.clothingItems.where().findAll();
  }

  /// Loads all data from the database and notifies listeners
  Future<void> loadData() async {
    await _loadOutfits();
    await _loadClothingItems();
    notifyListeners();
  }

  /// Retrieves all outfits with their associated clothing items loaded
  /// 
  /// Returns: A list of all outfits with their clothing items
  Future<List<Outfit>> getAllOutfits() async {
    final outfits = await isar.outfits.where().findAll();
    for (var outfit in outfits) {
      await outfit.clothingItems.load();
    }
    return outfits;
  }

  /// Adds a new outfit to the database
  /// 
  /// Parameters:
  /// - outfit: The outfit to add
  Future<void> addOutfit(Outfit outfit) async {
    await isar.writeTxn(() async {
      await isar.outfits.put(outfit);
    });
    await _loadOutfits();
    notifyListeners();
  }

  /// Adds a new clothing item to the database
  /// 
  /// Parameters:
  /// - item: The clothing item to add
  Future<void> addClothingItem(ClothingItem item) async {
    await isar.writeTxn(() async {
      await isar.clothingItems.put(item);
    });
    await _loadClothingItems();
    notifyListeners();
  }

  /// Deletes an outfit from the database
  /// 
  /// Parameters:
  /// - outfit: The outfit to delete
  Future<void> deleteOutfit(Outfit outfit) async {
    await isar.writeTxn(() async {
      await isar.outfits.delete(outfit.id);
    });
    await _loadOutfits();
    notifyListeners();
  }

  /// Deletes a clothing item from the database
  /// 
  /// Parameters:
  /// - item: The clothing item to delete
  Future<void> deleteClothingItem(ClothingItem item) async {
    await isar.writeTxn(() async {
      await isar.clothingItems.delete(item.id);
    });
    await _loadClothingItems();
    notifyListeners();
  }

  /// Adds a clothing item to an outfit
  /// 
  /// Parameters:
  /// - outfit: The outfit to add the item to
  /// - item: The clothing item to add
  Future<void> addItemToOutfit(Outfit outfit, ClothingItem item) async {
    await isar.writeTxn(() async {
      await isar.clothingItems.put(item);
      outfit.clothingItems.add(item);
      await outfit.clothingItems.save();
    });
    await _loadOutfits();
    notifyListeners();
  }

  /// Removes a clothing item from an outfit
  /// 
  /// Parameters:
  /// - outfit: The outfit to remove the item from
  /// - item: The clothing item to remove
  Future<void> removeItemFromOutfit(Outfit outfit, ClothingItem item) async {
    await isar.writeTxn(() async {
      outfit.clothingItems.remove(item);
      await outfit.clothingItems.save();
    });
    await _loadOutfits();
    notifyListeners();
  }

  /// Gets all clothing items in an outfit
  /// 
  /// Parameters:
  /// - outfit: The outfit to get items from
  /// Returns: A list of clothing items in the outfit
  Future<List<ClothingItem>> getOutfitItems(Outfit outfit) async {
    await outfit.clothingItems.load();
    return outfit.clothingItems.toList();
  }

  /// Clears all data from the database
  Future<void> clearDatabase() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
    _outfits = [];
    _clothingItems = [];
    notifyListeners();
  }

  /// Adds sample outfits to the database for testing purposes.
  /// Creates three outfits:
  /// 1. Summer Casual (sunny weather)
  /// 2. Rainy Day (rainy and gloomy weather)
  /// 3. Cloudy Day (gloomy weather)
  Future<void> addSampleOutfits() async {
    await clearDatabase();

    try {
      // Add Summer Casual outfit
      await isar.writeTxn(() async {
        final outfit = Outfit(
          name: 'Summer Casual',
          isForSunny: true,
          isForGloomy: false,
          isForRainy: false,
        );
        
        await isar.outfits.put(outfit);
        
        final items = [
          ClothingItem(description: 'White T-shirt', colorName: 'white'),
          ClothingItem(description: 'Blue Jeans', colorName: 'blue'),
          ClothingItem(description: 'Sunglasses', colorName: 'black'),
        ];
        
        for (var item in items) {
          await isar.clothingItems.put(item);
          outfit.clothingItems.add(item);
        }
        
        await outfit.clothingItems.save();
      });

      // Add Rainy Day outfit
      await isar.writeTxn(() async {
        final outfit = Outfit(
          name: 'Rainy Day',
          isForSunny: false,
          isForGloomy: true,
          isForRainy: true,
        );
        
        await isar.outfits.put(outfit);
        
        final items = [
          ClothingItem(description: 'Rain Jacket', colorName: 'yellow'),
          ClothingItem(description: 'Waterproof Boots', colorName: 'black'),
          ClothingItem(description: 'Umbrella', colorName: 'blue'),
        ];
        
        for (var item in items) {
          await isar.clothingItems.put(item);
          outfit.clothingItems.add(item);
        }
        
        await outfit.clothingItems.save();
      });

      // Add Cloudy Day outfit
      await isar.writeTxn(() async {
        final outfit = Outfit(
          name: 'Cloudy Day',
          isForSunny: false,
          isForGloomy: true,
          isForRainy: false,
        );
        
        await isar.outfits.put(outfit);
        
        final items = [
          ClothingItem(description: 'Light Sweater', colorName: 'gray'),
          ClothingItem(description: 'Dark Jeans', colorName: 'navy'),
          ClothingItem(description: 'Comfortable Shoes', colorName: 'brown'),
        ];
        
        for (var item in items) {
          await isar.clothingItems.put(item);
          outfit.clothingItems.add(item);
        }
        
        await outfit.clothingItems.save();
      });

      await _loadOutfits();
      await _loadClothingItems();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches an outfit by name and weather flags (for use after saving)
  Future<Outfit?> getOutfitByNameAndFlags(String name, bool isForGloomy, bool isForRainy, bool isForSunny) async {
    final results = await isar.outfits
        .filter()
        .nameEqualTo(name)
        .isForGloomyEqualTo(isForGloomy)
        .isForRainyEqualTo(isForRainy)
        .isForSunnyEqualTo(isForSunny)
        .findAll();
    return results.isNotEmpty ? results.last : null;
  }
}