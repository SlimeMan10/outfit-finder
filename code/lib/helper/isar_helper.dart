import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:outfit_finder/models/clothing_item.dart';
import 'package:outfit_finder/models/outfit.dart';

/// Initializes Isar with required collections
Future<Isar> initializeIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return await Isar.open(
    [ClothingItemSchema, OutfitSchema],
    directory: dir.path,
  );
} 