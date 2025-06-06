import 'package:flutter/material.dart';
import '../models/clothing_item.dart';
import '../helper/color_helper.dart';

// Widget for the displaying a clothing item
class ClothingItemWidget extends StatelessWidget {
  // item to display
  final ClothingItem item;
  // constructs a ClothingItemWidget with given item
  const ClothingItemWidget({super.key, required this.item});

  // builds a rounded tile widget for clothing item
  // shows item description and color
  @override
  Widget build(BuildContext context) {
    final colorHelper = ColorHelper();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorHelper.getColorFromString(item.colorName, context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        item.description,
        style: TextStyle(
          color: _getTextColorForBackground(
              colorHelper.getColorFromString(item.colorName, context)),
          fontSize: 16,
        ),
      ),
    );
  }

  Color _getTextColorForBackground(Color backgroundColor) {
    // Implement the logic to determine text color based on the background color
    // This is a placeholder and should be replaced with the actual implementation
    return Colors.white;
  }
}
