import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uni_connect/core/theme/app_theme.dart';
import 'package:uni_connect/core/widgets/shared_widgets.dart';
import 'package:uni_connect/features/budget/data/expense_model.dart';
import 'package:uni_connect/features/budget/providers/budget_provider.dart';

final _kesh = NumberFormat.currency(symbol: 'KES ', decimalDigits: 0);

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(budgetProvider);
    final isOverBudget = budget.budgetProgress >= 1.0;

    return Scaffold(
      backgroundColor: AppColors.offwhite,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ───────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.dark,
            title: const Text('Budget Tracker'),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune_rounded, color: Colors.white70),
                onPressed: () =>
                    _showBudgetDialog(context, ref, budget.monthlyBudget),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Budget Overview Card ─────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isOverBudget
                            ? [const Color(0xFF7F1D1D), AppColors.danger]
                            : [AppColors.dark, AppColors.dark2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total Spent',
                                    style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 4),
                                Text(
                                  _kesh.format(budget.totalSpent),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('Remaining',
                                    style: TextStyle(
                                        color: Colors.white60, fontSize: 13)),
                                const SizedBox(height: 4),
                                Text(
                                  _kesh.format(budget.remaining
                                      .clamp(0, double.infinity)),
                                  style: TextStyle(
                                      color: isOverBudget
                                          ? Colors.white54
                                          : AppColors.success,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: budget.budgetProgress,
                            minHeight: 8,
                            backgroundColor: Colors.white.withOpacity(0.15),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isOverBudget
                                  ? AppColors.danger
                                  : AppColors.success,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${(budget.budgetProgress * 100).toStringAsFixed(0)}% of budget used',
                              style: const TextStyle(
                                  color: Colors.white60, fontSize: 12),
                            ),
                            Text(
                              'Budget: ${_kesh.format(budget.monthlyBudget)}',
                              style: const TextStyle(
                                  color: Colors.white60, fontSize: 12),
                            ),
                          ],
                        ),
                        if (isOverBudget) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.warning_amber_rounded,
                                    color: Colors.white, size: 14),
                                SizedBox(width: 6),
                                Text('Over budget!',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

                  const SizedBox(height: 24),

                  // ── Category Breakdown ───────────────────────────────────
                  const SectionHeader(title: 'Spending by Category')
                      .animate()
                      .fadeIn(delay: 200.ms),
                  const SizedBox(height: 12),
                  _CategoryChart(
                          byCategory: budget.byCategory,
                          total: budget.totalSpent)
                      .animate()
                      .fadeIn(delay: 250.ms),

                  const SizedBox(height: 24),

                  // ── Transactions ─────────────────────────────────────────
                  SectionHeader(
                    title: 'Transactions (${budget.expenses.length})',
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 12),

                  if (budget.expenses.isEmpty)
                    const EmptyState(
                      icon: Icons.receipt_long_rounded,
                      title: 'No expenses yet',
                      subtitle: 'Tap + to log your first expense',
                    )
                  else
                    ...budget.expenses.asMap().entries.map((entry) {
                      final i = entry.key;
                      final expense = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Dismissible(
                          key: ValueKey(expense.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => ref
                              .read(budgetProvider.notifier)
                              .removeExpense(expense.id),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: AppColors.danger,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.delete_rounded,
                                color: Colors.white),
                          ),
                          child: _ExpenseTile(expense: expense)
                              .animate()
                              .fadeIn(delay: Duration(milliseconds: 50 * i))
                              .slideX(begin: 0.05),
                        ),
                      );
                    }),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseDialog(context, ref),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Expense',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ).animate().scale(delay: 400.ms),
    );
  }

  void _showAddExpenseDialog(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    String title = '', category = 'Food';
    double amount = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Log Expense',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.dark)),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.receipt_rounded),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                  onSaved: (v) => title = v!,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount (KES)',
                    prefixIcon: Icon(Icons.payments_rounded),
                  ),
                  validator: (v) {
                    if (v!.isEmpty) return 'Required';
                    if (double.tryParse(v) == null)
                      return 'Enter a valid number';
                    return null;
                  },
                  onSaved: (v) => amount = double.parse(v!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: expenseCategories
                      .map((c) => DropdownMenuItem(
                          value: c,
                          child: Row(children: [
                            Text(categoryIcons[c] ?? '📦'),
                            const SizedBox(width: 8),
                            Text(c),
                          ])))
                      .toList(),
                  onChanged: (v) => setState(() => category = v!),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        ref.read(budgetProvider.notifier).addExpense(
                              title: title,
                              amount: amount,
                              category: category,
                            );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Save Expense'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBudgetDialog(BuildContext context, WidgetRef ref, double current) {
    final ctrl = TextEditingController(text: current.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Set Monthly Budget'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Budget (KES)',
            prefixIcon: Icon(Icons.account_balance_wallet_rounded),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(ctrl.text);
              if (val != null && val > 0) {
                ref.read(budgetProvider.notifier).setBudget(val);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ─── Category Chart ───────────────────────────────────────────────────────────
class _CategoryChart extends StatelessWidget {
  final Map<String, double> byCategory;
  final double total;

  const _CategoryChart({required this.byCategory, required this.total});

  static const _catColors = {
    'Food': AppColors.warning,
    'Transport': AppColors.secondary,
    'Books': AppColors.primary,
    'Social': AppColors.purple,
    'Health': AppColors.success,
    'Other': AppColors.muted,
  };

  @override
  Widget build(BuildContext context) {
    if (byCategory.isEmpty) return const SizedBox.shrink();

    final sorted = byCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return UniCard(
      child: Column(
        children: sorted.map((entry) {
          final pct = total > 0 ? entry.value / total : 0.0;
          final color = _catColors[entry.key] ?? AppColors.muted;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Text(categoryIcons[entry.key] ?? '📦',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                SizedBox(
                  width: 72,
                  child: Text(entry.key,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textCol)),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 8,
                      backgroundColor: color.withOpacity(0.12),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 80,
                  child: Text(
                    _kesh.format(entry.value),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.dark),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Expense Tile ─────────────────────────────────────────────────────────────
class _ExpenseTile extends StatelessWidget {
  final ExpenseModel expense;
  const _ExpenseTile({required this.expense});

  @override
  Widget build(BuildContext context) {
    return UniCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.light,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                categoryIcons[expense.category] ?? '📦',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.dark)),
                const SizedBox(height: 2),
                Text(
                  '${expense.category}  •  ${DateFormat('MMM d').format(expense.date)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          Text(
            _kesh.format(expense.amount),
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.dark),
          ),
        ],
      ),
    );
  }
}
