import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';

class HiveService {
  static const String _boxName = "expense_box";

  static Future<void> init() async {
    await Hive.initFlutter();
    // Register the adapter so Hive knows how to handle the Expense class
    Hive.registerAdapter(ExpenseAdapter());
    await Hive.openBox<Expense>(_boxName);
  }

  static List<Expense> loadAll() {
    final box = Hive.box<Expense>(_boxName);
    return box.values.toList();
  }

  static Future<dynamic> addExpense(Expense expense) async {
    final box = Hive.box<Expense>(_boxName);
    return await box.add(expense);
  }

  static Future<void> deleteExpenseByKey(dynamic key) async {
    final box = Hive.box<Expense>(_boxName);
    await box.delete(key);
  }

  static Future<void> deleteExpenseById(String id) async {
    final box = Hive.box<Expense>(_boxName);
    final keyToDelete = box.keys.firstWhere(
      (k) => box.get(k)?.id == id,
      orElse: () => null,
    );
    if (keyToDelete != null) {
      await box.delete(keyToDelete);
    }
  }
}
