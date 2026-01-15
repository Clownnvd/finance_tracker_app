import 'package:flutter/material.dart';

class CategoryIconMapper {
  static IconData fromString(String icon) {
    switch (icon) {
      case 'house':
      case 'housing':
        return Icons.home_outlined;

      case 'work':
      case 'freelance':
        return Icons.work_outline;

      case 'money':
      case 'salary':
        return Icons.attach_money;

      case 'food':
        return Icons.restaurant;

      case 'shopping':
      case 'shopping_cart':
        return Icons.shopping_cart_outlined;

      case 'transport':
        return Icons.directions_car_outlined;

      case 'health':
        return Icons.favorite_border;

      case 'education':
        return Icons.school_outlined;

      default:
        return Icons.category_outlined;
    }
  }
}
