import 'package:flutter/material.dart';
import '../models/clothing_item.dart';
import '../helper/color_helper.dart';

class ClothingItemWidget extends StatelessWidget {
  final ClothingItem item;

  ClothingItemWidget({super.key, required this.item});
  final colorHelper = ColorHelper();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: const ShapeDecoration(
          color: Colors.white,
          shape: StadiumBorder(
              side: BorderSide(
            color: Color(0x33000000),
            width: 0.5,
          ))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.description,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
          ),
          const SizedBox(width: 8),
          Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                  color: colorHelper.getColorFromString(item.colorName),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0x33000000),
                    width: 0.5,
                  )))
        ],
      ),
    );
  }
}
