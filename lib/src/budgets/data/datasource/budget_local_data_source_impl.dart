import 'package:finanace_and_expense_app/src/budgets/data/datasource/budget_local_datasource.dart';
import 'package:finanace_and_expense_app/src/budgets/data/model/budget_model.dart';
import 'package:sqflite/sqflite.dart';

class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  final Database database;

  BudgetLocalDataSourceImpl(this.database);

  @override
  Future<List<BudgetModel>> getBudgets() async {
    final result = await database.query('budgets');
    return result.map((e) => BudgetModel.fromJson(e)).toList();
  }

  @override
  Future<void> addBudget(BudgetModel model) async {
    await database.insert(
      'budgets',
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateBudget(BudgetModel model) async {
    await database.update(
      'budgets',
      model.toJson(),
      where: 'category = ?',
      whereArgs: [model.category],
    );
  }

  @override
  Future<void> deleteBudget(String category) async {
    await database.delete(
      'budgets',
      where: 'category = ?',
      whereArgs: [category],
    );
  }
}
