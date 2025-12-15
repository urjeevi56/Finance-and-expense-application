import 'package:dartz/dartz.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/entities/transaction.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/repositories/transaction_repository.dart';
import 'package:smart_finance_tracker/core/error/failures.dart';
import 'package:smart_finance_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:smart_finance_tracker/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionUseCase {
  final TransactionRepository repository;

  TransactionUseCase(this.repository);

  /// Get transactions with optional limit
  Future<Either<Failure, List<Transaction>>> getTransactions({
    int limit = 0,
  }) async {
    return await repository.getTransactions(limit: limit);
  }

  /// Add transaction
  Future<Either<Failure, void>> addTransaction(
    Transaction transaction,
  ) async {
    return await repository.addTransaction(transaction);
  }

  /// Update transaction
  Future<Either<Failure, void>> updateTransaction(
    Transaction transaction,
  ) async {
    return await repository.updateTransaction(transaction);
  }

  /// Delete transaction
  Future<Either<Failure, void>> deleteTransaction(
    String id,
  ) async {
    return await repository.deleteTransaction(id);
  }
}
