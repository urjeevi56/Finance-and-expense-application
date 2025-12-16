import 'package:finanace_and_expense_app/src/budgets/domain/entity/budget.dart';

abstract class BudgetRepository {
  Future<List<Budget>> getBudgets();
  Future<void> addBudget(Budget budget);
  Future<void> updateBudget(Budget budget);
  Future<void> deleteBudget(String category);
}
