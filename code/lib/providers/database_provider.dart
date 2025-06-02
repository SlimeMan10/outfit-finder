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

  Future<void> loadData() async {
    await initializeIsar();
    await _loadOutfits();
    await _loadClothingItems();
    notifyListeners();
  }

  Future<void> _loadOutfits() async {
    _outfits = await isar.outfits.where().findAll();
  }

  Future<void> _loadClothingItems() async {
    _clothingItems = await isar.clothingItems.where().findAll();
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
}
