import 'package:finanace_and_expense_app/src/budgets/data/datasource/budget_local_datasource.dart';
import 'package:finanace_and_expense_app/src/budgets/data/model/budget_model.dart';
import 'package:finanace_and_expense_app/src/budgets/domain/entity/budget.dart';
import '../../domain/repository/budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetLocalDataSource local;

  BudgetRepositoryImpl(this.local);

  @override
  Future<List<Budget>> getBudgets() async {
    final models = await local.getBudgets();
    return models
        .map((m) => Budget(
              category: m.category,
              limit: m.limit,
              spent: m.spent,
            ))
        .toList();
  }

  @override
  Future<void> addBudget(Budget budget) {
    return local.addBudget(
      BudgetModel(
        category: budget.category,
        limit: budget.limit,
        spent: budget.spent,
      ),
    );
  }

  @override
  Future<void> deleteBudget(String category) {
    return local.deleteBudget(category);
  }

  @override
  Future<void> updateBudget(Budget budget) async {}
}
