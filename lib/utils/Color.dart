import 'package:flutter/material.dart';
import 'package:habit/utils/enums.dart';

class CategoryColors {
  static const Color physicalPrimary = Color.fromARGB(255, 190, 60, 60);
  static const Color physicalSecundary = Color.fromARGB(255, 150, 50, 50);

  static const Color mentalPrimary = Color.fromARGB(255, 55, 55, 175);
  static const Color mentalSecundary = Color.fromARGB(255, 50, 50, 150);

  static const Color socialPrimary = Color.fromARGB(255, 56, 173, 72);
  static const Color socialSecundary = Color.fromARGB(255, 50, 147, 55);

  static Color getPrimaryColor(Category category) {
    switch (category) {
      case Category.PHYSICAL:
        return physicalPrimary;
      case Category.MENTAL:
        return mentalPrimary;
      case Category.SOCIAL:
        return socialPrimary;
    }
  }

  static Color getSecundaryColor(Category category) {
    switch (category) {
      case Category.PHYSICAL:
        return physicalSecundary;
      case Category.MENTAL:
        return mentalSecundary;
      case Category.SOCIAL:
        return socialSecundary;
    }
  }
}
