/// Represents a wardrobe that manages a collection of outfits.
/// This class provides functionality to store, retrieve, and update outfits
/// in both memory and the Isar database.
import 'outfit.dart';
import 'package:isar/isar.dart';

// represents a wardrobe that holds the outfits of the app
class Wardrobe {
  /// Internal list of outfits stored in memory
  final List<Outfit> _outfits;
  // database with outfits
  final Isar _isar;

  /// Creates a new Wardrobe instance and initializes it with outfits from the database.
  /// 
  /// Parameters:
  /// - isar: The Isar database instance containing the outfits
  Wardrobe({required Isar isar})
      : _outfits = isar.outfits.where().findAllSync(),
        _isar = isar;

  /// Retrieves a copy of all outfits in the wardrobe.
  /// 
  /// Returns: A new list containing all outfits in the wardrobe
  List<Outfit> get outfits => List.from(_outfits);

  /// Updates an existing outfit or adds a new one to the wardrobe.
  /// This method updates both the in-memory collection and the database.
  /// 
  /// Parameters:
  /// - outfit: The outfit to update or insert
  void upsert({required Outfit outfit}) async {
    // Update local Wardrobe
    final outfitIds = _outfits.map((outfit) => outfit.id).toList();
    final indexId = outfitIds.indexOf(outfit.id);
    
    // If outfit ID not found, add as new outfit; otherwise update existing
    (indexId == -1)
        ? _outfits.add(outfit)
        : _outfits[indexId] = outfit;

    // Update Wardrobe in Isar database
    await _isar.writeTxn(() async {
      _isar.outfits.put(outfit);
    });
  }
}
