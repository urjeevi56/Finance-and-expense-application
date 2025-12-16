class BudgetModel {
  final String category;
  final double limit;
  final double spent;

  BudgetModel({
    required this.category,
    required this.limit,
    required this.spent,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      category: json['category'],
      limit: (json['limit'] as num).toDouble(),
      spent: (json['spent'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'limit': limit,
      'spent': spent,
    };
  }
}
