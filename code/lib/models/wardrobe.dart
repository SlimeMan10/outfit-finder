import 'outfit.dart';
import 'package:isar/isar.dart';

// represents a wardrobe that holds the outfits of the app
class Wardrobe {
  // outfits of wardrobe
  final List<Outfit> _outfits;
  // database with outfits
  final Isar _isar;

  // Constructs a Wardrobe with given database of outfits
  // Params:
  //  - isar: database with outfits to initialize
  Wardrobe({required Isar isar})
      : _outfits = isar.outfits.where().findAllSync(),
        _isar = isar;

  // gets and returns a copy of outfits
  List<Outfit> get outfits => List.from(_outfits);

  // updates given outfit if in _outfits
  // else adds into _outfits
  // Params:
  //  -outfit: outfit to either insert or update Wardrobe with
  void upsert({required Outfit outfit}) async {
    // update local Wardrobe
    final outfitIds = _outfits.map((outfit) => outfit.id).toList();
    final indexId = outfitIds.indexOf(outfit.id);
    (indexId == -1) // id not in _entries => is new outfit to add
        ? _outfits.add(outfit)
        : _outfits[indexId] = outfit; // replaces old outfit in _outfit

    // update Wardrobe in Isar
    await _isar.writeTxn(() async {
      _isar.outfits.put(outfit);
    });
  }
}
