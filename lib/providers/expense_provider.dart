import 'package:hive/hive.dart';

part 'expense.g.dart'; // This is for the generated adapter

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  dynamic key; // To store the Hive internal key

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.key,
  });
}
