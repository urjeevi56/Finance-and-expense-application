import 'package:finanace_and_expense_app/core/services/hive_service.dart';
import 'package:finanace_and_expense_app/core/theme/cubit/theme_cubit.dart';
import 'package:finanace_and_expense_app/src/transaction/data/datasource/transaction_local_data_source.dart';
import 'package:finanace_and_expense_app/src/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/repositories/transaction_repository.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/usecase/transaction_usecase.dart';
import 'package:finanace_and_expense_app/src/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:get_it/get_it.dart';


final GetIt sl = GetIt.instance;

Future<void> init() async {

  sl.registerFactory(() => ThemeCubit());
  

  sl.registerFactory(() => TransactionBloc(transactionUseCase: sl(),
    
  ));
  
 
  

  sl.registerLazySingleton(() => TransactionUseCase(sl()));

  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      localDataSource: sl(),
    ),
  );
  

  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(
      HiveService.transactionBox,
    ),
  );
}