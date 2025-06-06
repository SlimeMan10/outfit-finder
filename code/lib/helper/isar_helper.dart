import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:outfit_finder/models/clothing_item.dart';
import 'package:outfit_finder/models/outfit.dart';

// Isar database object
late Isar isar;

/// Initializes Isar with required collections
Future<void> initializeIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [ClothingItemSchema, OutfitSchema],
    directory: dir.path,
  );
} 