import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../models/category.dart' as cat;
import '../services/transaction_service.dart';
import '../services/category_service.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  List<cat.Category> _categories = [];
  bool _isLoading = false;
  String _searchQuery = '';
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  String? _filterCategory;

  // Getters
  List<Transaction> get transactions => _getFilteredTransactions();
  List<cat.Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  DateTime? get filterStartDate => _filterStartDate;
  DateTime? get filterEndDate => _filterEndDate;
  String? get filterCategory => _filterCategory;

  double get totalBalance => TransactionService.getTotalBalance();
  double get totalIncome => TransactionService.getTotalIncome(
    startDate: _filterStartDate,
    endDate: _filterEndDate,
  );
  double get totalExpenses => TransactionService.getTotalExpenses(
    startDate: _filterStartDate,
    endDate: _filterEndDate,
  );

  List<Transaction> get recentTransactions =>
      TransactionService.getRecentTransactions(limit: 5);

  Map<String, double> get spendingByCategory =>
      TransactionService.getSpendingByCategory(
        startDate: _filterStartDate,
        endDate: _filterEndDate,
      );

  // Initialize data
  Future<void> loadData() async {
    _setLoading(true);
    try {
      _transactions = TransactionService.getAllTransactions();
      _categories = CategoryService.getAllCategories();
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Add transaction
  Future<void> addTransaction(Transaction transaction) async {
    _setLoading(true);
    try {
      await TransactionService.addTransaction(transaction);
      _transactions = TransactionService.getAllTransactions();
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding transaction: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update transaction
  Future<void> updateTransaction(Transaction transaction) async {
    _setLoading(true);
    try {
      await TransactionService.updateTransaction(transaction);
      _transactions = TransactionService.getAllTransactions();
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating transaction: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Delete transaction
  Future<void> deleteTransaction(String id) async {
    _setLoading(true);
    try {
      await TransactionService.deleteTransaction(id);
      _transactions = TransactionService.getAllTransactions();
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Search transactions
  void searchTransactions(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Set date filter
  void setDateFilter(DateTime? startDate, DateTime? endDate) {
    _filterStartDate = startDate;
    _filterEndDate = endDate;
    notifyListeners();
  }

  // Set category filter
  void setCategoryFilter(String? categoryId) {
    _filterCategory = categoryId;
    notifyListeners();
  }

  // Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _filterStartDate = null;
    _filterEndDate = null;
    _filterCategory = null;
    notifyListeners();
  }

  // Get filtered transactions
  List<Transaction> _getFilteredTransactions() {
    List<Transaction> filtered = List.from(_transactions);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = TransactionService.searchTransactions(_searchQuery);
    }

    // Apply date filter
    if (_filterStartDate != null && _filterEndDate != null) {
      filtered =
          filtered
              .where(
                (transaction) =>
                    transaction.date.isAfter(
                      _filterStartDate!.subtract(const Duration(days: 1)),
                    ) &&
                    transaction.date.isBefore(
                      _filterEndDate!.add(const Duration(days: 1)),
                    ),
              )
              .toList();
    }

    // Apply category filter
    if (_filterCategory != null) {
      filtered =
          filtered
              .where((transaction) => transaction.category == _filterCategory)
              .toList();
    }

    return filtered;
  }

  // Get transaction by ID
  Transaction? getTransactionById(String id) {
    return TransactionService.getTransactionById(id);
  }

  // Get category by ID
  cat.Category? getCategoryById(String id) {
    return CategoryService.getCategoryById(id);
  }

  // Get expense categories
  List<cat.Category> getExpenseCategories() {
    return CategoryService.getExpenseCategories();
  }

  // Get income categories
  List<cat.Category> getIncomeCategories() {
    return CategoryService.getIncomeCategories();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
