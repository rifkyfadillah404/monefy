import 'package:hive/hive.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import 'database_service.dart';

class TransactionService {
  static Box<Transaction> get _box => DatabaseService.transactionBox;
  static Box<Category> get _categoryBox => DatabaseService.categoryBox;

  // Create a new transaction
  static Future<void> addTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  // Get all transactions
  static List<Transaction> getAllTransactions() {
    return _box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Sort by date descending
  }

  // Get transactions by type
  static List<Transaction> getTransactionsByType(TransactionType type) {
    return _box.values
        .where((transaction) => transaction.type == type)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get transactions by date range
  static List<Transaction> getTransactionsByDateRange(
      DateTime startDate, DateTime endDate) {
    return _box.values
        .where((transaction) =>
            transaction.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            transaction.date.isBefore(endDate.add(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get transactions by category
  static List<Transaction> getTransactionsByCategory(String categoryId) {
    return _box.values
        .where((transaction) => transaction.category == categoryId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Update a transaction
  static Future<void> updateTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  // Delete a transaction
  static Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  // Get transaction by ID
  static Transaction? getTransactionById(String id) {
    return _box.get(id);
  }

  // Calculate total balance
  static double getTotalBalance() {
    double balance = 0;
    for (final transaction in _box.values) {
      if (transaction.type == TransactionType.income) {
        balance += transaction.amount;
      } else {
        balance -= transaction.amount;
      }
    }
    return balance;
  }

  // Calculate total income
  static double getTotalIncome({DateTime? startDate, DateTime? endDate}) {
    var transactions = _box.values.where((t) => t.type == TransactionType.income);
    
    if (startDate != null && endDate != null) {
      transactions = transactions.where((t) =>
          t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          t.date.isBefore(endDate.add(const Duration(days: 1))));
    }
    
    return transactions.fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  // Calculate total expenses
  static double getTotalExpenses({DateTime? startDate, DateTime? endDate}) {
    var transactions = _box.values.where((t) => t.type == TransactionType.expense);
    
    if (startDate != null && endDate != null) {
      transactions = transactions.where((t) =>
          t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          t.date.isBefore(endDate.add(const Duration(days: 1))));
    }
    
    return transactions.fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  // Get spending by category
  static Map<String, double> getSpendingByCategory({DateTime? startDate, DateTime? endDate}) {
    var transactions = _box.values.where((t) => t.type == TransactionType.expense);
    
    if (startDate != null && endDate != null) {
      transactions = transactions.where((t) =>
          t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          t.date.isBefore(endDate.add(const Duration(days: 1))));
    }
    
    final Map<String, double> categorySpending = {};
    
    for (final transaction in transactions) {
      final category = _categoryBox.get(transaction.category);
      final categoryName = category?.name ?? 'Unknown';
      categorySpending[categoryName] = (categorySpending[categoryName] ?? 0) + transaction.amount;
    }
    
    return categorySpending;
  }

  // Get recent transactions (last 10)
  static List<Transaction> getRecentTransactions({int limit = 10}) {
    final transactions = getAllTransactions();
    return transactions.take(limit).toList();
  }

  // Search transactions
  static List<Transaction> searchTransactions(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _box.values
        .where((transaction) =>
            transaction.title.toLowerCase().contains(lowercaseQuery) ||
            (transaction.description?.toLowerCase().contains(lowercaseQuery) ?? false))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}
