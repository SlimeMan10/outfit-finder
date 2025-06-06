/// Represents a clothing item in the outfit finder application.
/// This class is used to store information about individual pieces of clothing,
/// including their description and color.
/// 
/// The class is annotated with @collection to enable Isar database storage.
import 'package:isar/isar.dart';

part 'clothing_item.g.dart';

// represents a clothing (or shoe/accessory) item
// (in an outfit)
@collection
class ClothingItem {
  /// Unique identifier for the clothing item in the database
  Id id = Isar.autoIncrement;

  /// Textual description of the clothing item (e.g., "Blue Jeans", "White T-shirt")
  final String description;

  /// Color of the clothing item represented as a string
  /// Note: Using string instead of Color object for Isar compatibility
  final String colorName;

  /// Creates a new ClothingItem instance.
  /// 
  /// Parameters:
  /// - description: A string describing the clothing item
  /// - colorName: The name of the color (e.g., "red", "blue", "green")
  ClothingItem({required this.description, required this.colorName});

  /// Compares this ClothingItem with another object for equality.
  /// Two ClothingItems are considered equal if they have the same ID.
  /// 
  /// Parameters:
  /// - other: The object to compare with
  /// Returns: true if the objects are equal, false otherwise
  @override
  bool operator ==(Object other) {
    return other is ClothingItem && other.id == id;
  }

  /// Generates a hash code for this ClothingItem based on its ID.
  /// This is required when overriding the == operator.
  /// 
  /// Returns: A hash code based on the item's ID
  @override
  int get hashCode => id.hashCode;
}
