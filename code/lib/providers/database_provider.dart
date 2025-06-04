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
    print('DEBUG: Loaded outfits from database:');
    for (var outfit in _outfits) {
      print('DEBUG: - ${outfit.name} (Sunny: ${outfit.isForSunny}, Gloomy: ${outfit.isForGloomy}, Rainy: ${outfit.isForRainy})');
    }
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
    // Load all clothing items for each outfit
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
    print('DEBUG: Clearing database...');
    await isar.writeTxn(() async {
      await isar.clear();
    });
    _outfits = [];
    _clothingItems = [];
    notifyListeners();
    print('DEBUG: Database cleared');
  }

  /// Debug method to print complete database state
  Future<void> debugDatabaseState() async {
    print('\n=== DATABASE DEBUG STATE ===');
    
    // Check total counts
    final outfitCount = await isar.outfits.count();
    final itemCount = await isar.clothingItems.count();
    
    print('Total outfits in database: $outfitCount');
    print('Total clothing items in database: $itemCount');
    
    // Get all outfits with their relationships
    final allOutfits = await isar.outfits.where().findAll();
    
    for (var outfit in allOutfits) {
      await outfit.clothingItems.load(); // Force load the relationship
      print('\nOutfit: ${outfit.name} (ID: ${outfit.id})');
      print('  Weather flags: Sunny=${outfit.isForSunny}, Gloomy=${outfit.isForGloomy}, Rainy=${outfit.isForRainy}');
      print('  Linked items count: ${outfit.clothingItems.length}');
      
      for (var item in outfit.clothingItems) {
        print('    - ${item.description} (${item.colorName}) [ID: ${item.id}]');
      }
    }
    
    // Also check orphaned clothing items (items not linked to any outfit)
    final allItems = await isar.clothingItems.where().findAll();
    print('\nAll clothing items in database:');
    for (var item in allItems) {
      print('  - ${item.description} (${item.colorName}) [ID: ${item.id}]');
    }
    
    print('=== END DEBUG STATE ===\n');
  }

  /// Verify data integrity
  Future<void> verifyDataIntegrity() async {
    print('\n=== VERIFYING DATA INTEGRITY ===');
    
    final outfits = await isar.outfits.where().findAll();
    bool hasIssues = false;
    
    for (var outfit in outfits) {
      await outfit.clothingItems.load();
      
      if (outfit.clothingItems.isEmpty) {
        print('WARNING: Outfit "${outfit.name}" has no clothing items!');
        hasIssues = true;
      }
      
      // Check if all linked items actually exist
      for (var item in outfit.clothingItems) {
        final existsInDb = await isar.clothingItems.get(item.id);
        if (existsInDb == null) {
          print('ERROR: Outfit "${outfit.name}" references non-existent item ID ${item.id}');
          hasIssues = true;
        }
      }
    }
    
    if (!hasIssues) {
      print('✓ Data integrity check passed!');
    }
    
    print('=== END INTEGRITY CHECK ===\n');
  }

  /// Test method to get all outfits regardless of weather
  Future<void> testAllOutfits() async {
    print('\n=== TESTING ALL OUTFITS ===');
    
    final allOutfits = await isar.outfits.where().findAll();
    print('Found ${allOutfits.length} total outfits:');
    
    for (var outfit in allOutfits) {
      await outfit.clothingItems.load();
      print('\nOutfit: ${outfit.name}');
      print('  - For Sunny: ${outfit.isForSunny}');
      print('  - For Gloomy: ${outfit.isForGloomy}');
      print('  - For Rainy: ${outfit.isForRainy}');
      print('  - Items (${outfit.clothingItems.length}):');
      
      for (var item in outfit.clothingItems) {
        print('    * ${item.description} (${item.colorName})');
      }
    }
    
    print('=== END TEST ===\n');
  }

  /// Fixed version - each outfit created in separate transaction
  Future<void> addSampleOutfits() async {
    print('DEBUG: Starting to add sample outfits...');
    
    // First clear the database to ensure a clean state
    await clearDatabase();

    try {
      // Create Summer Outfit in its own transaction
      print('DEBUG: Creating Summer Casual outfit...');
      await isar.writeTxn(() async {
        final outfit = Outfit(
          name: 'Summer Casual',
          isForSunny: true,
          isForGloomy: false,
          isForRainy: false,
        );
        
        // Save outfit first
        await isar.outfits.put(outfit);
        print('DEBUG: Summer outfit saved with ID: ${outfit.id}');
        
        // Create and save items
        final items = [
          ClothingItem(description: 'White T-shirt', colorName: 'white'),
          ClothingItem(description: 'Blue Jeans', colorName: 'blue'),
          ClothingItem(description: 'Sunglasses', colorName: 'black'),
        ];
        
        for (var item in items) {
          await isar.clothingItems.put(item);
          outfit.clothingItems.add(item);
          print('DEBUG: Added ${item.description} (ID: ${item.id}) to Summer outfit');
        }
        
        await outfit.clothingItems.save();
        print('DEBUG: Summer outfit relationships saved');
      });

      // Create Rainy Outfit in its own transaction
      print('DEBUG: Creating Rainy Day outfit...');
      await isar.writeTxn(() async {
        final outfit = Outfit(
          name: 'Rainy Day',
          isForSunny: false,
          isForGloomy: true,
          isForRainy: true,
        );
        
        // Save outfit first
        await isar.outfits.put(outfit);
        print('DEBUG: Rainy outfit saved with ID: ${outfit.id}');
        
        // Create and save items
        final items = [
          ClothingItem(description: 'Rain Jacket', colorName: 'yellow'),
          ClothingItem(description: 'Waterproof Boots', colorName: 'black'),
          ClothingItem(description: 'Umbrella', colorName: 'blue'),
        ];
        
        for (var item in items) {
          await isar.clothingItems.put(item);
          outfit.clothingItems.add(item);
          print('DEBUG: Added ${item.description} (ID: ${item.id}) to Rainy outfit');
        }
        
        await outfit.clothingItems.save();
        print('DEBUG: Rainy outfit relationships saved');
      });

      // Create Cloudy Outfit in its own transaction
      print('DEBUG: Creating Cloudy Day outfit...');
      await isar.writeTxn(() async {
        final outfit = Outfit(
          name: 'Cloudy Day',
          isForSunny: false,
          isForGloomy: true,
          isForRainy: false,
        );
        
        // Save outfit first
        await isar.outfits.put(outfit);
        print('DEBUG: Cloudy outfit saved with ID: ${outfit.id}');
        
        // Create and save items
        final items = [
          ClothingItem(description: 'Light Sweater', colorName: 'gray'),
          ClothingItem(description: 'Dark Jeans', colorName: 'navy'),
          ClothingItem(description: 'Comfortable Shoes', colorName: 'brown'),
        ];
        
        for (var item in items) {
          await isar.clothingItems.put(item);
          outfit.clothingItems.add(item);
          print('DEBUG: Added ${item.description} (ID: ${item.id}) to Cloudy outfit');
        }
        
        await outfit.clothingItems.save();
        print('DEBUG: Cloudy outfit relationships saved');
      });

      // Verify the data was added correctly
      print('DEBUG: Verifying database contents...');
      final outfitsAfter = await isar.outfits.where().findAll();
      print('DEBUG: Number of outfits after adding samples: ${outfitsAfter.length}');
      
      for (var outfit in outfitsAfter) {
        await outfit.clothingItems.load();
        print('DEBUG: - ${outfit.name} (ID: ${outfit.id}) has ${outfit.clothingItems.length} items:');
        for (var item in outfit.clothingItems) {
          print('DEBUG:   * ${item.description} (${item.colorName}) [ID: ${item.id}]');
        }
      }

      // Load data into local variables
      await _loadOutfits();
      await _loadClothingItems();
      notifyListeners();
      
      print('DEBUG: Sample outfits added successfully!');
    } catch (e) {
      print('ERROR: Failed to add sample outfits: $e');
      rethrow;
    }
  }
}