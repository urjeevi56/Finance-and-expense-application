import 'package:finanace_and_expense_app/src/budgets/domain/entity/budget.dart';
import 'package:finanace_and_expense_app/src/budgets/domain/repository/budget_repository.dart';

class BudgetUseCase {
  final BudgetRepository repository;

  BudgetUseCase(this.repository);

  Future<List<Budget>> getBudgets() {
    return repository.getBudgets();
  }

  Future<void> addBudget(Budget budget) {
    return repository.addBudget(budget);
  }
}
