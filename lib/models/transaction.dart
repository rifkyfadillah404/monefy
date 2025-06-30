import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double amount;

  @HiveField(3)
  TransactionType type;

  @HiveField(4)
  String category;

  @HiveField(5)
  DateTime date;

  @HiveField(6)
  String? description;

  @HiveField(7)
  String? iconName;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.description,
    this.iconName,
  });

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    String? category,
    DateTime? date,
    String? description,
    String? iconName,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
    );
  }

  @override
  String toString() {
    return 'Transaction(id: $id, title: $title, amount: $amount, type: $type, category: $category, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Transaction &&
        other.id == id &&
        other.title == title &&
        other.amount == amount &&
        other.type == type &&
        other.category == category &&
        other.date == date &&
        other.description == description &&
        other.iconName == iconName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        amount.hashCode ^
        type.hashCode ^
        category.hashCode ^
        date.hashCode ^
        description.hashCode ^
        iconName.hashCode;
  }
}

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}
