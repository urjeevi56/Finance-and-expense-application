import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:finanace_and_expense_app/core/services/export_service.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/entities/transaction.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/usecase/transaction_usecase.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionUseCase transactionUseCase;

  TransactionBloc({
    required this.transactionUseCase,
  }) : super(const TransactionState()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransactionEvent>(_onAddTransaction);
    on<UpdateTransactionEvent>(_onUpdateTransaction);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
    on<FilterTransactions>(_onFilterTransactions);
    on<ExportTransactions>(_onExportTransactions);
  }

 
  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    final result = await transactionUseCase.getTransactions(
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TransactionStatus.error,
          errorMessage: failure.toString(),
        ),
      ),
      (transactions) => emit(
        state.copyWith(
          status: TransactionStatus.success,
          transactions: transactions,
          categories: _extractCategories(transactions),
        ),
      ),
    );
  }


  Future<void> _onAddTransaction(
    AddTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    final result =
        await transactionUseCase.addTransaction(event.transaction);

    result.fold(
      (failure) => emit(
        state.copyWith(errorMessage: failure.toString()),
      ),
      (_) => add(const LoadTransactions()),
    );
  }

  Future<void> _onUpdateTransaction(
    UpdateTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    final result =
        await transactionUseCase.updateTransaction(event.transaction);

    result.fold(
      (failure) => emit(
        state.copyWith(errorMessage: failure.toString()),
      ),
      (_) => add(const LoadTransactions()),
    );
  }

  Future<void> _onDeleteTransaction(
    DeleteTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    final result =
        await transactionUseCase.deleteTransaction(event.id);

    result.fold(
      (failure) => emit(
        state.copyWith(errorMessage: failure.toString()),
      ),
      (_) => add(const LoadTransactions()),
    );
  }

  Future<void> _onFilterTransactions(
    FilterTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(
      state.copyWith(
        filterCategory: event.category,
        filterStartDate: event.startDate,
        filterEndDate: event.endDate,
      ),
    );
  }

  Future<void> _onExportTransactions(
    ExportTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(exportLoading: true));

    try {
      await ExportService.exportToCSV(state.transactions);
      emit(state.copyWith(exportLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          exportLoading: false,
          exportError: 'Export failed: ${e.toString()}',
        ),
      );
    }
  }

  List<String> _extractCategories(List<Transaction> transactions) {
    final categories = transactions.map((t) => t.category).toSet().toList();
    categories.sort();
    return categories;
  }
}
