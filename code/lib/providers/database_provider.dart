import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../models/clothing_item.dart';
import '../models/outfit.dart';
import '../models/wardrobe.dart';

class DatabaseProvider extends ChangeNotifier {
  late final Wardrobe _wardrobe;
  bool _isInitialized = false;

  DatabaseProvider(Isar isar) {
    _wardrobe = Wardrobe(isar: isar);
    _initialize();
  }

  // Getter for integration tests
  Wardrobe get journal => _wardrobe;

  Future<void> _initialize() async {
    await _wardrobe.loadEntries();
    _isInitialized = true;
    notifyListeners();
  }

  List<Outfit> get entries {
    if (!_isInitialized) return [];
    return _wardrobe.entries;
  }

  Future<void> upsertJournalEntry(JournalEntry entry) async {
    await _journal.upsertEntry(entry);
    notifyListeners();
  }

  Future<void> deleteEntry(JournalEntry entry) async {
    await _journal.deleteEntry(entry);
    notifyListeners();
  }
} 