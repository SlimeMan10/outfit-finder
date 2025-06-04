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
    return await isar.outfits.where().findAll();
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

  /// Adds sample outfits to the database for testing
  Future<void> addSampleOutfits() async {
    // Clear existing data
    await isar.writeTxn(() async {
      await isar.clear();
    });

    // Create sample outfits
    final summerOutfit = Outfit(
      name: 'Summer Casual',
      isForSunny: true,
      isForGloomy: false,
      isForRainy: false,
    );

    final rainyOutfit = Outfit(
      name: 'Rainy Day',
      isForSunny: false,
      isForGloomy: true,
      isForRainy: true,
    );

    final cloudyOutfit = Outfit(
      name: 'Cloudy Day',
      isForSunny: false,
      isForGloomy: true,
      isForRainy: false,
    );

    // Create clothing items
    final summerItems = [
      ClothingItem(description: 'White T-shirt', colorName: 'white'),
      ClothingItem(description: 'Blue Jeans', colorName: 'blue'),
      ClothingItem(description: 'Sunglasses', colorName: 'black'),
    ];

    final rainyItems = [
      ClothingItem(description: 'Rain Jacket', colorName: 'yellow'),
      ClothingItem(description: 'Waterproof Boots', colorName: 'black'),
      ClothingItem(description: 'Umbrella', colorName: 'blue'),
    ];

    final cloudyItems = [
      ClothingItem(description: 'Light Sweater', colorName: 'gray'),
      ClothingItem(description: 'Dark Jeans', colorName: 'navy'),
      ClothingItem(description: 'Comfortable Shoes', colorName: 'brown'),
    ];

    // Add outfits and their items to the database
    await isar.writeTxn(() async {
      await isar.outfits.put(summerOutfit);
      await isar.outfits.put(rainyOutfit);
      await isar.outfits.put(cloudyOutfit);

      for (var item in summerItems) {
        await isar.clothingItems.put(item);
        summerOutfit.clothingItems.add(item);
      }
      await summerOutfit.clothingItems.save();

      for (var item in rainyItems) {
        await isar.clothingItems.put(item);
        rainyOutfit.clothingItems.add(item);
      }
      await rainyOutfit.clothingItems.save();

      for (var item in cloudyItems) {
        await isar.clothingItems.put(item);
        cloudyOutfit.clothingItems.add(item);
      }
      await cloudyOutfit.clothingItems.save();
    });

    await _loadOutfits();
    await _loadClothingItems();
    notifyListeners();
  }
}
