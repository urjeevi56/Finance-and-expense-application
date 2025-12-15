import 'package:sqflite/sqflite.dart';
import '../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getTransactions({int? limit});
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<List<TransactionModel>> getTransactionsByCategory(String category);
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  );
  Future<double> getTotalIncome();
  Future<double> getTotalExpense();
}

class TransactionLocalDataSourceImpl
    implements TransactionLocalDataSource {
  final Database database;

  TransactionLocalDataSourceImpl(this.database);

  @override
  Future<List<TransactionModel>> getTransactions({int? limit}) async {
    final maps = await database.query(
      'transactions',
      orderBy: 'date DESC',
      limit: limit,
    );

    return maps.map(TransactionModel.fromJson).toList();
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await database.insert(
      'transactions',
      transaction.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await database.update(
      'transactions',
      transaction.toJson(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await database.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<TransactionModel>> getTransactionsByCategory(
    String category,
  ) async {
    final maps = await database.query(
      'transactions',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'date DESC',
    );

    return maps.map(TransactionModel.fromJson).toList();
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final maps = await database.query(
      'transactions',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [
        start.toIso8601String(),
        end.toIso8601String(),
      ],
      orderBy: 'date DESC',
    );

    return maps.map(TransactionModel.fromJson).toList();
  }

  @override
  Future<double> getTotalIncome() async {
    final result = await database.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE type = 0',
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  @override
  Future<double> getTotalExpense() async {
    final result = await database.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE type = 1',
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }
}
