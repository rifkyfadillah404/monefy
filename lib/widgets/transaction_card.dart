import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../services/category_service.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final category = CategoryService.getCategoryById(transaction.category);
    final isIncome = transaction.type == TransactionType.income;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive margins and padding
    final horizontalMargin = screenWidth * 0.05; // 5% of screen width
    final verticalMargin = screenHeight * 0.008; // 0.8% of screen height
    final cardPadding = screenHeight < 700 ? 16.0 : 20.0;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalMargin,
        vertical: verticalMargin,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Category Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          (category?.color ?? Colors.grey).withValues(
                            alpha: 0.1,
                          ),
                          (category?.color ?? Colors.grey).withValues(
                            alpha: 0.05,
                          ),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: (category?.color ?? Colors.grey).withValues(
                          alpha: 0.1,
                        ),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      _getIconData(category?.iconName ?? 'more_horiz'),
                      color: category?.color ?? Colors.grey,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Transaction Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            color: const Color(0xFF1F2937),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: (category?.color ?? Colors.grey)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  category?.name ?? 'Unknown',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color: category?.color ?? Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                DateFormat(
                                  'dd MMM yyyy',
                                ).format(transaction.date),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (transaction.description != null &&
                            transaction.description!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            transaction.description!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[500]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Amount and Actions
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isIncome
                                    ? const Color(
                                      0xFF10B981,
                                    ).withValues(alpha: 0.1)
                                    : const Color(
                                      0xFFEF4444,
                                    ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${isIncome ? '+' : '-'}${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(transaction.amount)}',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                                color:
                                    isIncome
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFFEF4444),
                              ),
                            ),
                          ),
                        ),
                        if (onDelete != null) ...[
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: onDelete,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'movie':
        return Icons.movie;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'school':
        return Icons.school;
      case 'receipt':
        return Icons.receipt;
      case 'work':
        return Icons.work;
      case 'laptop':
        return Icons.laptop;
      case 'trending_up':
        return Icons.trending_up;
      case 'card_giftcard':
        return Icons.card_giftcard;
      default:
        return Icons.more_horiz;
    }
  }
}
