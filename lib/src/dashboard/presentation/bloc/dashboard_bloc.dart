import 'package:bloc/bloc.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/usecase/transaction_usecase.dart';
import '../../../transaction/domain/entities/transaction.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final TransactionUseCase usecase;
  
  DashboardBloc({
    required this.usecase,
  }) : super(const DashboardState()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }
  
  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    
  final result = await usecase.getTransactions(limit: 50);

    
    result.fold(
      (failure) => emit(state.copyWith(
        status: DashboardStatus.error,
        errorMessage: failure.toString(),
      )),
      (transactions) {
        final totalIncome = _calculateTotalIncome(transactions);
        final totalExpense = _calculateTotalExpense(transactions);
        final expensesByCategory = _calculateExpensesByCategory(transactions);
        
        emit(state.copyWith(
          status: DashboardStatus.success,
          transactions: transactions,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          balance: totalIncome - totalExpense,
          expensesByCategory: expensesByCategory,
        ));
      },
    );
  }
  
  double _calculateTotalIncome(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }
  
  double _calculateTotalExpense(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }
  
  Map<String, double> _calculateExpensesByCategory(List<Transaction> transactions) {
    final Map<String, double> result = {};
    
    for (final transaction in transactions) {
      if (transaction.type == TransactionType.expense) {
        result.update(
          transaction.category,
          (value) => value + transaction.amount,
          ifAbsent: () => transaction.amount,
        );
      }
    }
    
    return result;
  }
}