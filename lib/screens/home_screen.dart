import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_card.dart';
import '../models/transaction.dart';
import 'add_transaction_screen.dart';
import 'transaction_history_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          _HomeTab(),
          TransactionHistoryScreen(),
          StatisticsScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: const Color(0xFF6366F1),
              unselectedItemColor: Colors.grey[400],
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_rounded),
                  activeIcon: Icon(Icons.history_rounded),
                  label: 'Riwayat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_rounded),
                  activeIcon: Icon(Icons.bar_chart_rounded),
                  label: 'Statistik',
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showAddTransactionModal(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add_rounded, size: 28, color: Colors.white),
        ),
      ),
    );
  }

  void _showAddTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const AddTransactionScreen(),
          ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Consumer<TransactionProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // App Bar
                  SliverAppBar(
                    expandedHeight:
                        MediaQuery.of(context).size.height *
                        0.08, // 8% of screen height
                    floating: true,
                    backgroundColor: const Color(0xFFF8FAFC),
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFF8FAFC), Color(0xFFFFFFFF)],
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Selamat datang! 👋',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Monefy',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.headlineMedium?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF1F2937),
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.05,
                                            ),
                                            blurRadius: 10,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.notifications_rounded,
                                        color: Colors.grey[600],
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Balance Card
                  SliverToBoxAdapter(
                    child: BalanceCard(
                      balance: provider.totalBalance,
                      income: provider.totalIncome,
                      expenses: provider.totalExpenses,
                    ),
                  ),

                  // Quick Actions
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _QuickActionButton(
                              icon: Icons.add,
                              label: 'Tambah Pemasukan',
                              color: Colors.green,
                              onTap:
                                  () => _showAddTransactionModal(
                                    context,
                                    TransactionType.income,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _QuickActionButton(
                              icon: Icons.remove,
                              label: 'Tambah Pengeluaran',
                              color: Colors.red,
                              onTap:
                                  () => _showAddTransactionModal(
                                    context,
                                    TransactionType.expense,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Recent Transactions Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Transaksi Terbaru',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to transaction history screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const TransactionHistoryScreen(),
                                ),
                              );
                            },
                            child: const Text('Lihat Semua'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Recent Transactions List
                  provider.recentTransactions.isEmpty
                      ? SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Belum ada transaksi',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Mulai catat pemasukan dan pengeluaran Anda',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[500]),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                      : SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final transaction =
                              provider.recentTransactions[index];
                          return TransactionCard(
                            transaction: transaction,
                            onDelete:
                                () => _showDeleteConfirmation(
                                  context,
                                  transaction,
                                ),
                          );
                        }, childCount: provider.recentTransactions.length),
                      ),

                  // Bottom padding
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height:
                          constraints.maxHeight *
                          0.08, // 8% of available height
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _showAddTransactionModal(BuildContext context, TransactionType type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: AddTransactionScreen(initialType: type),
          ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hapus Transaksi'),
            content: Text(
              'Apakah Anda yakin ingin menghapus transaksi "${transaction.title}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  context.read<TransactionProvider>().deleteTransaction(
                    transaction.id,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Hapus'),
              ),
            ],
          ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive padding and sizes
    final containerPadding = screenHeight < 700 ? 12.0 : 16.0;
    final iconSize = screenHeight < 700 ? 20.0 : 24.0;
    final iconPadding = screenHeight < 700 ? 8.0 : 10.0;
    final spacing = screenHeight < 700 ? 6.0 : 8.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(containerPadding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(iconPadding),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: iconSize),
              ),
              SizedBox(height: spacing),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.1,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
