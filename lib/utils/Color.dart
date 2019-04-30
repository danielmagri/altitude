import 'package:flutter/material.dart';
import 'package:habit/utils/enums.dart';

class CategoryColors {
  static const Color physicalPrimary = Color.fromARGB(255, 255, 0, 0);
  static const Color physicalSecundary = Color.fromARGB(255, 221, 221, 221);

  static const Color mentalPrimary = Color.fromARGB(255, 0, 255, 0);
  static const Color mentalSecundary = Color.fromARGB(255, 221, 221, 221);

  static const Color socialPrimary = Color.fromARGB(255, 0, 0, 255);
  static const Color socialSecundary = Color.fromARGB(255, 221, 221, 221);

  static Color getColor(Category category) {
    switch (category) {
      case Category.PHYSICAL:
        return physicalPrimary;
      case Category.MENTAL:
        return mentalPrimary;
      case Category.SOCIAL:
        return socialPrimary;
    }
  }
}
