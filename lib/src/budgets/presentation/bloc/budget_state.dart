import 'package:equatable/equatable.dart';
import 'package:finanace_and_expense_app/src/budgets/domain/entity/budget.dart';

enum BudgetStatus { initial, loading, success, error }

class BudgetState extends Equatable {
  final BudgetStatus status;
  final List<Budget> budgets;
  final String? errorMessage;

  const BudgetState({
    this.status = BudgetStatus.initial,
    this.budgets = const [],
    this.errorMessage,
  });

  BudgetState copyWith({
    BudgetStatus? status,
    List<Budget>? budgets,
    String? errorMessage,
  }) {
    return BudgetState(
      status: status ?? this.status,
      budgets: budgets ?? this.budgets,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, budgets, errorMessage];
}

