import 'package:flutter/material.dart';

/// Home Screen Categories
const List<Map<String, dynamic>> mockCategories = [
  {'name': 'Coffee', 'icon': Icons.coffee, 'isSelected': true},
  {'name': 'Non-Coffee', 'icon': Icons.local_drink, 'isSelected': false},
  {'name': 'Meh', 'icon': Icons.tag_faces, 'isSelected': false},
  {'name': 'S...', 'icon': Icons.cloud, 'isSelected': false},
];

/// Menu Filter Categories
const List<Map<String, dynamic>> filterCategories = [
  {'name': 'All Coffees', 'icon': Icons.coffee, 'isSelected': true},
  {'name': 'Espresso', 'icon': Icons.local_cafe, 'isSelected': false},
  {'name': 'Latte', 'icon': Icons.local_drink, 'isSelected': false},
  {'name': 'Iced', 'icon': Icons.icecream, 'isSelected': false},
];
