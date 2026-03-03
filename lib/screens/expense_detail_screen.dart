import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class ExpenseDetailScreen extends StatelessWidget {
  const ExpenseDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    // Do not listen to provider here — if the item is deleted while this
    // page is still mounted, rebuilding and calling `firstWhere` would
    // throw a StateError (No element). We capture the list once and
    // handle the missing-item case gracefully.
    final prov = Provider.of<ExpenseProvider>(context, listen: false);
    final expenses = prov.expenses;
    final idx = expenses.indexWhere((e) => e.id == id);
    if (idx == -1) {
      // Item not found (probably deleted). Close this page after build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      });
      return Scaffold(
        appBar: AppBar(title: const Text('Expense Detail')),
        body: const Center(child: Text('Expense not found')),
      );
    }
    final expense = expenses[idx];

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Amount: \$${expense.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1565C0))),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text('${expense.date.toLocal()}'.split(' ')[0]),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white),
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          await prov.deleteExpense(expense);
                          navigator.pop();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text('Delete'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text('Back'),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
