import 'package:equatable/equatable.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/entities/transaction.dart';

enum TransactionStatus { initial, loading, success, error }

class TransactionState extends Equatable {
  final TransactionStatus status;
  final List<Transaction> transactions;
  final String? errorMessage;
  final List<String> categories;
  final String? filterCategory;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final bool exportLoading;
  final String? exportError;
  
  const TransactionState({
    this.status = TransactionStatus.initial,
    this.transactions = const [],
    this.errorMessage,
    this.categories = const [],
    this.filterCategory,
    this.filterStartDate,
    this.filterEndDate,
    this.exportLoading = false,
    this.exportError,
  });
  
  // Helper getters
  double get totalIncome => transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0, (sum, t) => sum + t.amount);
  
  double get totalExpense => transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);
  
  double get balance => totalIncome - totalExpense;
  
  List<Transaction> get filteredTransactions {
    List<Transaction> result = List.from(transactions);
    
    if (filterCategory != null) {
      result = result.where((t) => t.category == filterCategory).toList();
    }
    
    if (filterStartDate != null) {
      result = result.where((t) => t.date.isAfter(filterStartDate!)).toList();
    }
    
    if (filterEndDate != null) {
      result = result.where((t) => t.date.isBefore(filterEndDate!)).toList();
    }
    
    return result;
  }
  
  Map<String, double> get expensesByCategory {
    final Map<String, double> result = {};
    for (var transaction in transactions.where((t) => t.type == TransactionType.expense)) {
      result.update(
        transaction.category,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }
    return result;
  }
  
  List<Transaction> get recentTransactions {
    return transactions.take(5).toList();
  }
  
  TransactionState copyWith({
    TransactionStatus? status,
    List<Transaction>? transactions,
    String? errorMessage,
    List<String>? categories,
    String? filterCategory,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    bool? exportLoading,
    String? exportError,
  }) {
    return TransactionState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
      categories: categories ?? this.categories,
      filterCategory: filterCategory ?? this.filterCategory,
      filterStartDate: filterStartDate ?? this.filterStartDate,
      filterEndDate: filterEndDate ?? this.filterEndDate,
      exportLoading: exportLoading ?? this.exportLoading,
      exportError: exportError ?? this.exportError,
    );
  }
  
  @override
  List<Object?> get props => [
    status,
    transactions,
    errorMessage,
    categories,
    filterCategory,
    filterStartDate,
    filterEndDate,
    exportLoading,
    exportError,
  ];
}