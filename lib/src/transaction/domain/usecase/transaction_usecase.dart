import 'package:dartz/dartz.dart';
import 'package:finanace_and_expense_app/core/error/failures.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/entities/transaction.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/repositories/transaction_repository.dart';

class TransactionUseCase {
  final TransactionRepository repository;

  TransactionUseCase(this.repository);

  Future<Either<Failure, List<Transaction>>> getTransactions({
    int? limit,
  }) async {
    return await repository.getTransactions(limit: limit);
  }

  Future<Either<Failure, void>> addTransaction(
    Transaction transaction,
  ) async {
    return await repository.addTransaction(transaction);
  }

  Future<Either<Failure, void>> updateTransaction(
    Transaction transaction,
  ) async {
    return await repository.updateTransaction(transaction);
  }

  Future<Either<Failure, void>> deleteTransaction(
    String id,
  ) async {
    return await repository.deleteTransaction(id);
  }
}

