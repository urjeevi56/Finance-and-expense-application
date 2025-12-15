import 'package:dartz/dartz.dart';
import 'package:finanace_and_expense_app/core/error/failures.dart';
import 'package:finanace_and_expense_app/src/transaction/data/datasource/transaction_local_data_source.dart';
import 'package:finanace_and_expense_app/src/transaction/data/models/transaction_model.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/entities/transaction.dart' as domain_entity;
import 'package:finanace_and_expense_app/src/transaction/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<domain_entity.Transaction>>> getTransactions({int? limit}) async {
    try {
      final transactions = await localDataSource.getTransactions(limit: limit);
      return Right(transactions.map((model) => _toEntity(model)).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain_entity.Transaction>> getTransactionById(String id) async {
    try {
      
      throw UnimplementedError();
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addTransaction(domain_entity.Transaction transaction) async {
    try {
      await localDataSource.addTransaction(_toModel(transaction));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTransaction(domain_entity.Transaction transaction) async {
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
  Future<Either<Failure, List<domain_entity.Transaction>>> getTransactionsByCategory(
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
  Future<Either<Failure, List<domain_entity.Transaction>>> getTransactionsByDateRange(
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

  domain_entity.Transaction _toEntity(TransactionModel model) {
    return domain_entity.Transaction(
      id: model.id,
      title: model.title,
      amount: model.amount,
      category: model.category,
      date: model.date,
      type: model.type == TransactionType.income 
          ? domain_entity.TransactionType.income 
          : domain_entity.TransactionType.expense,
      description: model.description,
    );
  }

  TransactionModel _toModel(domain_entity.Transaction entity) {
    return TransactionModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      category: entity.category,
      date: entity.date,
      type: entity.type == domain_entity.TransactionType.income 
          ? TransactionType.income 
          : TransactionType.expense,
      description: entity.description,
    );
  }
}