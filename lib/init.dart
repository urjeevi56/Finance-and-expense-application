import 'package:finanace_and_expense_app/src/budgets/data/datasource/budget_local_data_source_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import 'package:finanace_and_expense_app/core/services/database_service.dart';
import 'package:finanace_and_expense_app/core/theme/cubit/theme_cubit.dart';

import 'package:finanace_and_expense_app/src/transaction/data/datasource/transaction_local_data_source.dart';
import 'package:finanace_and_expense_app/src/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/repositories/transaction_repository.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/usecase/transaction_usecase.dart';
import 'package:finanace_and_expense_app/src/transaction/presentation/bloc/transaction_bloc.dart';

import 'package:finanace_and_expense_app/src/dashboard/presentation/bloc/dashboard_bloc.dart';

import 'package:finanace_and_expense_app/src/budgets/data/datasource/budget_local_datasource.dart';
import 'package:finanace_and_expense_app/src/budgets/data/repository/budget_repository_impl.dart';
import 'package:finanace_and_expense_app/src/budgets/domain/repository/budget_repository.dart';
import 'package:finanace_and_expense_app/src/budgets/domain/usecase/budget_usecase.dart';
import 'package:finanace_and_expense_app/src/budgets/presentation/bloc/budget_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final Database database = await DatabaseService.database;
  sl.registerLazySingleton<Database>(() => database);

  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton(
    () => TransactionUseCase(sl()),
  );

  sl.registerFactory(
    () => TransactionBloc(transactionUseCase: sl()),
  );

  sl.registerFactory(
    () => DashboardBloc(usecase: sl()),
  );

  sl.registerLazySingleton<BudgetLocalDataSource>(
    () => BudgetLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<BudgetRepository>(
    () => BudgetRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(
    () => BudgetUseCase(sl()),
  );

  sl.registerFactory(
    () => BudgetBloc(sl()),
  );

  sl.registerFactory(
    () => ThemeCubit(),
  );
}
