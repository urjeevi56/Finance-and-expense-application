import 'dart:async';

import 'package:finanace_and_expense_app/src/transaction/data/models/transaction_model.dart';
import 'package:hive/hive.dart';
import 'package:smart_finance_tracker/features/transactions/data/models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getTransactions({int? limit});
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<List<TransactionModel>> getTransactionsByCategory(String category);
  Future<List<TransactionModel>> getTransactionsByDateRange(DateTime start, DateTime end);
  Future<double> getTotalIncome();
  Future<double> getTotalExpense();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final Box<TransactionModel> _transactionBox;

  TransactionLocalDataSourceImpl(this._transactionBox);

  @override
  Future<List<TransactionModel>> getTransactions({int? limit}) async {
    final transactions = _transactionBox.values.toList();
    transactions.sort((a, b) => b.date.compareTo(a.date));
    
    if (limit != null && transactions.length > limit) {
      return transactions.sublist(0, limit);
    }
    
    return transactions;
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _transactionBox.delete(id);
  }

  @override
  Future<List<TransactionModel>> getTransactionsByCategory(String category) async {
    final transactions = _transactionBox.values
        .where((transaction) => transaction.category == category)
        .toList();
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions;
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final transactions = _transactionBox.values
        .where((transaction) => 
            transaction.date.isAfter(start) && transaction.date.isBefore(end))
        .toList();
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions;
  }

  @override
  Future<double> getTotalIncome() async {
    final transactions = _transactionBox.values
        .where((transaction) => transaction.type == TransactionType.income)
        .toList();
    return transactions.fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  @override
  Future<double> getTotalExpense() async {
    final transactions = _transactionBox.values
        .where((transaction) => transaction.type == TransactionType.expense)
        .toList();
    return transactions.fold(0.0, (sum, transaction) => sum + transaction.amount);
  }
}

extension on FutureOr<double> {
  FutureOr<double> operator +(double other) {}
}