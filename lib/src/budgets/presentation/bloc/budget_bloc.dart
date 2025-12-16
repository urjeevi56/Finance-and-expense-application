import 'package:bloc/bloc.dart';
import 'package:finanace_and_expense_app/src/budgets/domain/usecase/budget_usecase.dart';
import 'package:finanace_and_expense_app/src/budgets/presentation/bloc/budget_event.dart';
import 'package:finanace_and_expense_app/src/budgets/presentation/bloc/budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final BudgetUseCase useCase;

  BudgetBloc(this.useCase) : super(const BudgetState()) {
    on<LoadBudgets>(_onLoadBudgets);
    on<AddBudget>(_onAddBudget);
  }

  Future<void> _onLoadBudgets(
    LoadBudgets event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.loading));

    final budgets = await useCase.getBudgets();

    emit(state.copyWith(
      status: BudgetStatus.success,
      budgets: budgets,
    ));
  }

  Future<void> _onAddBudget(
    AddBudget event,
    Emitter<BudgetState> emit,
  ) async {
    await useCase.addBudget(event.budget);
    add(LoadBudgets());
  }
}

