import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:uni_connect/features/budget/data/expense_model.dart';

final _uuid = Uuid();

class BudgetState {
  final List<ExpenseModel> expenses;
  final double monthlyBudget;

  const BudgetState({
    required this.expenses,
    required this.monthlyBudget,
  });

  double get totalSpent => expenses.fold(0.0, (sum, e) => sum + e.amount);

  double get remaining => monthlyBudget - totalSpent;

  double get budgetProgress => (totalSpent / monthlyBudget).clamp(0.0, 1.0);

  Map<String, double> get byCategory {
    final map = <String, double>{};
    for (final e in expenses) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }

  BudgetState copyWith({
    List<ExpenseModel>? expenses,
    double? monthlyBudget,
  }) =>
      BudgetState(
        expenses: expenses ?? this.expenses,
        monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      );
}

class BudgetNotifier extends StateNotifier<BudgetState> {
  BudgetNotifier()
      : super(BudgetState(
          monthlyBudget: 8000,
          expenses: _seedExpenses(),
        ));

  void addExpense({
    required String title,
    required double amount,
    required String category,
  }) {
    final expense = ExpenseModel(
      id: _uuid.v4(),
      title: title,
      amount: amount,
      category: category,
      date: DateTime.now(),
    );
    state = state.copyWith(expenses: [expense, ...state.expenses]);
  }

  void removeExpense(String id) {
    state = state.copyWith(
        expenses: state.expenses.where((e) => e.id != id).toList());
  }

  void setBudget(double amount) {
    state = state.copyWith(monthlyBudget: amount);
  }
}

final budgetProvider = StateNotifierProvider<BudgetNotifier, BudgetState>(
    (ref) => BudgetNotifier());

List<ExpenseModel> _seedExpenses() {
  final now = DateTime.now();
  return [
    ExpenseModel(
        id: '1',
        title: 'Lunch at cafeteria',
        amount: 350,
        category: 'Food',
        date: now.subtract(const Duration(days: 0))),
    ExpenseModel(
        id: '2',
        title: 'Bus fare',
        amount: 100,
        category: 'Transport',
        date: now.subtract(const Duration(days: 1))),
    ExpenseModel(
        id: '3',
        title: 'Flutter book',
        amount: 1200,
        category: 'Books',
        date: now.subtract(const Duration(days: 2))),
    ExpenseModel(
        id: '4',
        title: 'Team dinner',
        amount: 800,
        category: 'Social',
        date: now.subtract(const Duration(days: 3))),
    ExpenseModel(
        id: '5',
        title: 'Groceries',
        amount: 650,
        category: 'Food',
        date: now.subtract(const Duration(days: 4))),
    ExpenseModel(
        id: '6',
        title: 'Matatu to town',
        amount: 150,
        category: 'Transport',
        date: now.subtract(const Duration(days: 5))),
    ExpenseModel(
        id: '7',
        title: 'Painkillers',
        amount: 200,
        category: 'Health',
        date: now.subtract(const Duration(days: 6))),
  ];
}
