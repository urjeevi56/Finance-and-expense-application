import 'package:dartz/dartz.dart';
import 'package:finanace_and_expense_app/core/error/failures.dart';
import 'package:finanace_and_expense_app/src/transaction/data/datasource/transaction_local_data_source.dart';
import 'package:finanace_and_expense_app/src/transaction/data/models/transaction_model.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/entities/transaction.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/repositories/transaction_repository.dart';
import 'package:smart_finance_tracker/core/error/failures.dart';
import 'package:smart_finance_tracker/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:smart_finance_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:smart_finance_tracker/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions({int? limit}) async {
    try {
      final transactions = await localDataSource.getTransactions(limit: limit);
      return Right(transactions.map((model) => _toEntity(model)).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getTransactionById(String id) async {
    try {
      // Implementation would fetch by ID
      throw UnimplementedError();
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addTransaction(Transaction transaction) async {
    try {
      await localDataSource.addTransaction(_toModel(transaction));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTransaction(Transaction transaction) async {
    try {
      await localDataSource.updateTransaction(_toModel(transaction));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      await localDataSource.deleteTransaction(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByCategory(
    String category,
  ) async {
    try {
      final transactions = await localDataSource.getTransactionsByCategory(category);
      return Right(transactions.map((model) => _toEntity(model)).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final transactions = await localDataSource.getTransactionsByDateRange(start, end);
      return Right(transactions.map((model) => _toEntity(model)).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalIncome() async {
    try {
      final total = await localDataSource.getTotalIncome();
      return Right(total);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalExpense() async {
    try {
      final total = await localDataSource.getTotalExpense();
      return Right(total);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getExpensesByCategory() async {
    try {
      final transactions = await localDataSource.getTransactions();
      final expenseByCategory = <String, double>{};
      
      for (final transaction in transactions) {
        if (transaction.type == TransactionType.expense) {
          expenseByCategory.update(
            transaction.category,
            (value) => value + transaction.amount,
            ifAbsent: () => transaction.amount,
          );
        }
      }
      
      return Right(expenseByCategory);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  Transaction _toEntity(TransactionModel model) {
    return Transaction(
      id: model.id,
      title: model.title,
      amount: model.amount,
      category: model.category,
      date: model.date,
      type: model.type == TransactionType.income 
          ? TransactionType.income 
          : TransactionType.expense,
      description: model.description,
    );
  }

  TransactionModel _toModel(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      category: entity.category,
      date: entity.date,
      type: entity.type == TransactionType.income 
          ? TransactionType.income 
          : TransactionType.expense,
      description: entity.description,
    );
  }
}