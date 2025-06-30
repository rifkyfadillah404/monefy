import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_card.dart';
import '../widgets/category_chip.dart';
import '../models/transaction.dart';
import 'add_transaction_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<TransactionProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Riwayat Transaksi',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Search Bar
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari transaksi...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    provider.searchTransactions('');
                                  },
                                  icon: const Icon(Icons.clear),
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: (value) {
                          provider.searchTransactions(value);
                          setState(() {});
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Filter Row
                      Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _FilterChip(
                                    label: 'Semua',
                                    isSelected: provider.filterCategory == null,
                                    onTap: () => provider.setCategoryFilter(null),
                                  ),
                                  const SizedBox(width: 8),
                                  ...provider.categories.map((category) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: CategoryChip(
                                        category: category,
                                        isSelected: provider.filterCategory == category.id,
                                        onTap: () => provider.setCategoryFilter(
                                          provider.filterCategory == category.id 
                                              ? null 
                                              : category.id,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _showFilterDialog(context, provider),
                            icon: Icon(
                              Icons.tune,
                              color: (provider.filterStartDate != null || 
                                     provider.filterEndDate != null)
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Transactions List
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.transactions.isEmpty
                          ? _buildEmptyState(context)
                          : ListView.builder(
                              itemCount: provider.transactions.length,
                              itemBuilder: (context, index) {
                                final transaction = provider.transactions[index];
                                return TransactionCard(
                                  transaction: transaction,
                                  onTap: () => _editTransaction(context, transaction),
                                  onDelete: () => _showDeleteConfirmation(
                                    context, 
                                    transaction,
                                  ),
                                );
                              },
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada transaksi ditemukan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coba ubah filter atau kata kunci pencarian',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context, TransactionProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Tanggal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Tanggal Mulai'),
              subtitle: Text(
                provider.filterStartDate != null
                    ? DateFormat('dd MMM yyyy').format(provider.filterStartDate!)
                    : 'Belum dipilih',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: provider.filterStartDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  provider.setDateFilter(date, provider.filterEndDate);
                }
              },
            ),
            ListTile(
              title: const Text('Tanggal Akhir'),
              subtitle: Text(
                provider.filterEndDate != null
                    ? DateFormat('dd MMM yyyy').format(provider.filterEndDate!)
                    : 'Belum dipilih',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: provider.filterEndDate ?? DateTime.now(),
                  firstDate: provider.filterStartDate ?? DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  provider.setDateFilter(provider.filterStartDate, date);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              provider.clearFilters();
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _editTransaction(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: AddTransactionScreen(transaction: transaction),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Transaksi'),
        content: Text('Apakah Anda yakin ingin menghapus transaksi "${transaction.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              context.read<TransactionProvider>().deleteTransaction(transaction.id);
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).primaryColor 
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
