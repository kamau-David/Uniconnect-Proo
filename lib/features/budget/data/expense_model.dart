class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  const ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });
}

const expenseCategories = [
  'Food',
  'Transport',
  'Books',
  'Social',
  'Health',
  'Other'
];

const categoryIcons = {
  'Food': '🍔',
  'Transport': '🚌',
  'Books': '📚',
  'Social': '🎉',
  'Health': '💊',
  'Other': '📦',
};
