import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import 'package:finanace_and_expense_app/core/services/database_service.dart';
import 'package:finanace_and_expense_app/src/transaction/data/datasource/transaction_local_data_source.dart';
import 'package:finanace_and_expense_app/src/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/repositories/transaction_repository.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/usecase/transaction_usecase.dart';
import 'package:finanace_and_expense_app/src/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:finanace_and_expense_app/src/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:finanace_and_expense_app/core/theme/cubit/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Database
  final Database database = await DatabaseService.database;
  sl.registerLazySingleton<Database>(() => database);

  // Data source
  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(sl()),
  );

  // ✅ REGISTER REPOSITORY (THIS FIXES THE ERROR)
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(localDataSource: sl()),
  );

  // Use case
  sl.registerLazySingleton(
    () => TransactionUseCase(sl()),
  );

  // Blocs
  sl.registerFactory(
    () => TransactionBloc(transactionUseCase: sl()),
  );

  sl.registerFactory(
    () => DashboardBloc(usecase: sl()),
  );

  sl.registerFactory(
    () => ThemeCubit(),
  );
}
