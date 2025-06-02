import 'package:flutter/material.dart';

// represents a clothing (or shoe/accessory) item
// (in an outfit)
class ClothingItem {
  // could implement item id but outfits prob won't have many items

  // description of clothing item
  final String description;

  // color of clothing item
  final Color color;

  // Constructs a Clothing item with given description and color
  // (both required named params)
  // Params:
  //  description: description of item
  //  color: color of item,
  ClothingItem({required this.description, required this.color});

  // checks equality of other ClothingItem with this
  // (for finding item to delete)
  @override
  bool operator ==(Object other) {
    return other is ClothingItem &&
        other.description == description &&
        other.color == color;
  }

  // corresponding override to ==
  @override
  int get hashCode => description.hashCode;
}
