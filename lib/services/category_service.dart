import 'package:hive/hive.dart';
import '../models/category.dart';
import 'database_service.dart';

class CategoryService {
  static Box<Category> get _box => DatabaseService.categoryBox;

  // Get all categories
  static List<Category> getAllCategories() {
    return _box.values.toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  // Get categories for expenses
  static List<Category> getExpenseCategories() {
    // For simplicity, we'll return categories that are commonly used for expenses
    // In a more complex app, you might want to add a field to Category to specify its type
    final expenseIds = [
      'food',
      'transport',
      'shopping',
      'entertainment',
      'health',
      'education',
      'bills',
      'other_expense',
    ];

    return _box.values
        .where((category) => expenseIds.contains(category.id))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  // Get categories for income
  static List<Category> getIncomeCategories() {
    final incomeIds = [
      'salary',
      'freelance',
      'investment',
      'gift',
      'other_income',
    ];

    return _box.values
        .where((category) => incomeIds.contains(category.id))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  // Add a new category
  static Future<void> addCategory(Category category) async {
    await _box.put(category.id, category);
  }

  // Update a category
  static Future<void> updateCategory(Category category) async {
    await _box.put(category.id, category);
  }

  // Delete a category
  static Future<void> deleteCategory(String id) async {
    // Don't delete default categories
    final category = _box.get(id);
    if (category != null && !category.isDefault) {
      await _box.delete(id);
    }
  }

  // Get category by ID
  static Category? getCategoryById(String id) {
    return _box.get(id);
  }

  // Get category by name
  static Category? getCategoryByName(String name) {
    return _box.values.firstWhere(
      (category) => category.name.toLowerCase() == name.toLowerCase(),
      orElse: () => _box.values.first, // Return first category as fallback
    );
  }

  // Check if category exists
  static bool categoryExists(String id) {
    return _box.containsKey(id);
  }

  // Get categories with transaction count
  static Map<Category, int> getCategoriesWithTransactionCount() {
    final categories = getAllCategories();
    final transactionBox = DatabaseService.transactionBox;
    final Map<Category, int> categoryCount = {};

    for (final category in categories) {
      final count =
          transactionBox.values
              .where((transaction) => transaction.category == category.id)
              .length;
      categoryCount[category] = count;
    }

    return categoryCount;
  }

  // Get most used categories
  static List<Category> getMostUsedCategories({int limit = 5}) {
    final categoryCount = getCategoriesWithTransactionCount();
    final sortedEntries =
        categoryCount.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.take(limit).map((entry) => entry.key).toList();
  }
}
