import 'package:finanace_and_expense_app/src/budgets/data/model/budget_model.dart';

abstract class BudgetLocalDataSource {
  Future<List<BudgetModel>> getBudgets();
  Future<void> addBudget(BudgetModel model);
  Future<void> updateBudget(BudgetModel model);
  Future<void> deleteBudget(String category);
}
