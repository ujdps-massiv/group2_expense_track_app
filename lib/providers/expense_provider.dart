import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../services/hive_service.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses =>
      _expenses..sort((a, b) => b.date.compareTo(a.date));

  double get totalSpent => _expenses.fold(0.0, (s, e) => s + e.amount);

  Future<void> loadExpenses() async {
    _expenses = HiveService.loadAll();
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    final key = await HiveService.addExpense(expense);
    expense.key = key;
    _expenses.add(expense);
    notifyListeners();
  }

  Future<void> deleteExpense(Expense expense) async {
    if (expense.key != null) {
      await HiveService.deleteExpenseByKey(expense.key!);
    } else {
      // fallback: try to delete by numeric id (search box)
      await HiveService.deleteExpenseById(expense.id);
    }
    _expenses.removeWhere((e) => e.key == expense.key || e.id == expense.id);
    notifyListeners();
  }
}
