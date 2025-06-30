import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';
import '../models/category.dart';

class DatabaseService {
  static const String _transactionBoxName = 'transactions';
  static const String _categoryBoxName = 'categories';
  
  static Box<Transaction>? _transactionBox;
  static Box<Category>? _categoryBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(TransactionTypeAdapter());
    Hive.registerAdapter(CategoryAdapter());
    
    // Open boxes
    _transactionBox = await Hive.openBox<Transaction>(_transactionBoxName);
    _categoryBox = await Hive.openBox<Category>(_categoryBoxName);
    
    // Initialize default categories if empty
    await _initializeDefaultCategories();
  }

  static Future<void> _initializeDefaultCategories() async {
    if (_categoryBox!.isEmpty) {
      // Add default expense categories
      for (final category in defaultExpenseCategories) {
        await _categoryBox!.put(category.id, category);
      }
      
      // Add default income categories
      for (final category in defaultIncomeCategories) {
        await _categoryBox!.put(category.id, category);
      }
    }
  }

  static Box<Transaction> get transactionBox {
    if (_transactionBox == null) {
      throw Exception('Database not initialized. Call DatabaseService.init() first.');
    }
    return _transactionBox!;
  }

  static Box<Category> get categoryBox {
    if (_categoryBox == null) {
      throw Exception('Database not initialized. Call DatabaseService.init() first.');
    }
    return _categoryBox!;
  }

  static Future<void> close() async {
    await _transactionBox?.close();
    await _categoryBox?.close();
  }
}
