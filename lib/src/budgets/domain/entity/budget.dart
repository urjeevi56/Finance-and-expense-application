class Budget {
  final String category;
  final double limit;
  final double spent;

  const Budget({
    required this.category,
    required this.limit,
    required this.spent,
  });

  bool get isOverBudget => spent > limit;
  bool get isNearLimit => spent >= limit * 0.8;
}
