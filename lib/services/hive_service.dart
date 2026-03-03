import 'package:hive_flutter/hive_flutter.dart';

import '../models/expense.dart';

class HiveService {
  static const String boxName = 'expenses';

  /// Initialize Hive and open a typed box for Expense objects.
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ExpenseAdapter());
    await Hive.openBox<Expense>(boxName);
  }

  static Box<Expense> getBox() => Hive.box<Expense>(boxName);

  static List<Expense> loadAll() {
    final box = getBox();
    final List<Expense> list = [];
    for (final dynamic key in box.keys) {
      final exp = box.get(key) as Expense;
      // ensure the expense remembers its storage key
      exp.key ??= key.toString();
      list.add(exp);
    }
    return list;
  }

  /// Use a string key for storing expenses to avoid the 32-bit unsigned
  /// integer key limitation in Hive. We keep the numeric `id` inside the
  /// object for application logic, but the box key is the id as a string.
  /// Adds an expense to the box. Uses a string key.
  /// If `expense.key` is null, a unique string key is generated and returned.
  /// Returns the key used to store the expense.
  static Future<String> addExpense(Expense expense) async {
    final box = getBox();
    final key = expense.key ?? DateTime.now().microsecondsSinceEpoch.toString();
    expense.key ??= key;
    await box.put(key, expense);
    return key;
  }

  /// Delete by converting the numeric id to the same string key used when
  /// storing the object.
  /// Delete by the string key.
  static Future<void> deleteExpenseByKey(String key) async {
    final box = getBox();
    await box.delete(key);
  }

  /// Find an expense by its numeric id and delete it. This helps when the
  /// in-memory Expense doesn't have its `key` field populated.
  static Future<void> deleteExpenseById(int id) async {
    final box = getBox();
    String? foundKey;
    for (final dynamic key in box.keys) {
      final exp = box.get(key) as Expense;
      if (exp.id == id) {
        foundKey = key.toString();
        break;
      }
    }
    if (foundKey != null) {
      await box.delete(foundKey);
    }
  }
}
