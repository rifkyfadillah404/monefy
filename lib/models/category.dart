import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class Category extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String iconName;

  @HiveField(3)
  int colorValue;

  @HiveField(4)
  bool isDefault;

  Category({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorValue,
    this.isDefault = false,
  });

  Color get color => Color(colorValue);

  Category copyWith({
    String? id,
    String? name,
    String? iconName,
    int? colorValue,
    bool? isDefault,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      colorValue: colorValue ?? this.colorValue,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, iconName: $iconName, colorValue: $colorValue, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category &&
        other.id == id &&
        other.name == name &&
        other.iconName == iconName &&
        other.colorValue == colorValue &&
        other.isDefault == isDefault;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        iconName.hashCode ^
        colorValue.hashCode ^
        isDefault.hashCode;
  }
}

// Default categories for expenses
final List<Category> defaultExpenseCategories = [
  Category(
    id: 'food',
    name: 'Makanan',
    iconName: 'restaurant',
    colorValue: Colors.orange.value,
    isDefault: true,
  ),
  Category(
    id: 'transport',
    name: 'Transportasi',
    iconName: 'directions_car',
    colorValue: Colors.blue.value,
    isDefault: true,
  ),
  Category(
    id: 'shopping',
    name: 'Belanja',
    iconName: 'shopping_bag',
    colorValue: Colors.pink.value,
    isDefault: true,
  ),
  Category(
    id: 'entertainment',
    name: 'Hiburan',
    iconName: 'movie',
    colorValue: Colors.purple.value,
    isDefault: true,
  ),
  Category(
    id: 'health',
    name: 'Kesehatan',
    iconName: 'local_hospital',
    colorValue: Colors.red.value,
    isDefault: true,
  ),
  Category(
    id: 'education',
    name: 'Pendidikan',
    iconName: 'school',
    colorValue: Colors.green.value,
    isDefault: true,
  ),
  Category(
    id: 'bills',
    name: 'Tagihan',
    iconName: 'receipt',
    colorValue: Colors.brown.value,
    isDefault: true,
  ),
  Category(
    id: 'other_expense',
    name: 'Lainnya',
    iconName: 'more_horiz',
    colorValue: Colors.grey.value,
    isDefault: true,
  ),
];

// Default categories for income
final List<Category> defaultIncomeCategories = [
  Category(
    id: 'salary',
    name: 'Gaji',
    iconName: 'work',
    colorValue: Colors.green.value,
    isDefault: true,
  ),
  Category(
    id: 'freelance',
    name: 'Freelance',
    iconName: 'laptop',
    colorValue: Colors.teal.value,
    isDefault: true,
  ),
  Category(
    id: 'investment',
    name: 'Investasi',
    iconName: 'trending_up',
    colorValue: Colors.indigo.value,
    isDefault: true,
  ),
  Category(
    id: 'gift',
    name: 'Hadiah',
    iconName: 'card_giftcard',
    colorValue: Colors.pink.value,
    isDefault: true,
  ),
  Category(
    id: 'other_income',
    name: 'Lainnya',
    iconName: 'more_horiz',
    colorValue: Colors.grey.value,
    isDefault: true,
  ),
];
