import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:outfit_finder/helper/isar_helper.dart';
import 'package:outfit_finder/models/outfit.dart';
import 'package:outfit_finder/models/clothing_item.dart';

class DatabaseProvider extends ChangeNotifier {
  List<Outfit> _outfits = [];
  List<ClothingItem> _clothingItems = [];

  List<Outfit> get outfits => _outfits;
  List<ClothingItem> get clothingItems => _clothingItems;

  Future<void> _loadOutfits() async {
    _outfits = await isar.outfits.where().findAll();
  }

  Future<void> _loadClothingItems() async {
    _clothingItems = await isar.clothingItems.where().findAll();
  }

  Future<void> loadData() async {
    await _loadOutfits();
    await _loadClothingItems();
    notifyListeners();
  }

  Future<List<Outfit>> getAllOutfits() async {
    final outfits = await isar.outfits.where().findAll();
    for (var outfit in outfits) {
      await outfit.clothingItems.load();
    }
    return outfits;
  }

  Future<void> addOutfit(Outfit outfit) async {
    await isar.writeTxn(() async {
      await isar.outfits.put(outfit);
    });
    await _loadOutfits();
    notifyListeners();
  }

  Future<void> addClothingItem(ClothingItem item) async {
    await isar.writeTxn(() async {
      await isar.clothingItems.put(item);
    });
    await _loadClothingItems();
    notifyListeners();
  }

  Future<void> deleteOutfit(Outfit outfit) async {
    await isar.writeTxn(() async {
      await isar.outfits.delete(outfit.id!);
    });
    await _loadOutfits();
    notifyListeners();
  }

  Future<void> deleteClothingItem(ClothingItem item) async {
    await isar.writeTxn(() async {
      await isar.clothingItems.delete(item.id!);
    });
    await _loadClothingItems();
    notifyListeners();
  }

  Future<void> addItemToOutfit(Outfit outfit, ClothingItem item) async {
    await isar.writeTxn(() async {
      await isar.clothingItems.put(item);
      outfit.clothingItems.add(item);
      await outfit.clothingItems.save();
    });
    await _loadOutfits();
    notifyListeners();
  }

  Future<void> removeItemFromOutfit(Outfit outfit, ClothingItem item) async {
    await isar.writeTxn(() async {
      outfit.clothingItems.remove(item);
      await outfit.clothingItems.save();
    });
    await _loadOutfits();
    notifyListeners();
  }

  Future<List<ClothingItem>> getOutfitItems(Outfit outfit) async {
    await outfit.clothingItems.load();
    return outfit.clothingItems.toList();
  }

  Future<void> clearDatabase() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
    _outfits = [];
    _clothingItems = [];
    notifyListeners();
  }

  Future<void> addSampleOutfits() async {
    await clearDatabase();

    try {
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
}