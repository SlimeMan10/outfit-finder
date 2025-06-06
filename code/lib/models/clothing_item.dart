import 'package:isar/isar.dart';

part 'clothing_item.g.dart';

// represents a clothing (or shoe/accessory) item
// (in an outfit)
@collection
class ClothingItem {
  // unique identifier for the item
  Id id = Isar.autoIncrement;

  // description of clothing item
  final String description;

  // color of clothing item as a preset name
  /// Isar doesnt like using Color objects, so we are going to use strings instead
  /// we just need frontend conversion to Color object
  final String colorName;

  // Constructs a Clothing item with given description and color
  // Parameters:
  //  description: description of item
  //  colorName: name of the color (e.g., "red", "blue", "green")
  ClothingItem({required this.description, required this.colorName});

  // checks equality of other ClothingItem with this
  // (for finding item to delete)
  @override
  bool operator ==(Object other) {
    return other is ClothingItem && other.id == id;
  }

  // corresponding override to ==
  @override
  int get hashCode => id.hashCode;
}
