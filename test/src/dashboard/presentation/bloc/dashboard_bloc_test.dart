import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:finanace_and_expense_app/core/error/failures.dart';
import 'package:finanace_and_expense_app/src/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:finanace_and_expense_app/src/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:finanace_and_expense_app/src/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/entities/transaction.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/usecase/transaction_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionUseCase extends Mock
    implements TransactionUseCase {}

void main() {
  late MockTransactionUseCase mockTransactionUseCase;
  late DashboardBloc dashboardBloc;

  final testTransactions = [
    Transaction(
      id: '1',
      title: 'Salary',
      amount: 5000.0,
      category: 'Salary',
      date: DateTime(2024, 1, 1),
      type: TransactionType.income,
    ),
    Transaction(
      id: '2',
      title: 'Food',
      amount: 1000.0,
      category: 'Food',
      date: DateTime(2024, 1, 2),
      type: TransactionType.expense,
    ),
    Transaction(
      id: '3',
      title: 'Transport',
      amount: 500.0,
      category: 'Transport',
      date: DateTime(2024, 1, 3),
      type: TransactionType.expense,
    ),
  ];

  setUp(() {
    mockTransactionUseCase = MockTransactionUseCase();
    dashboardBloc = DashboardBloc(usecase: mockTransactionUseCase);
  });

  tearDown(() {
    dashboardBloc.close();
  });

  group('DashboardBloc', () {
    test('initial state is DashboardState.initial', () {
      expect(dashboardBloc.state, const DashboardState());
    });

    blocTest<DashboardBloc, DashboardState>(
      'emits [loading, success] when LoadDashboardData succeeds',
      build: () {
        when(() => mockTransactionUseCase.getTransactions(
              limit: any(named: 'limit'),
            )).thenAnswer((_) async => Right(testTransactions));
        return dashboardBloc;
      },
      act: (bloc) => bloc.add(LoadDashboardData()),
      expect: () => [
        const DashboardState(status: DashboardStatus.loading),
        DashboardState(
          status: DashboardStatus.success,
          transactions: testTransactions,
          totalIncome: 5000.0,
          totalExpense: 1500.0,
          balance: 3500.0,
          expensesByCategory: const {
            'Food': 1000.0,
            'Transport': 500.0,
          },
        ),
      ],
      verify: (_) {
        verify(() => mockTransactionUseCase.getTransactions(
              limit: 50,
            )).called(1);
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'emits [loading, error] when LoadDashboardData fails',
      build: () {
        when(() => mockTransactionUseCase.getTransactions(
              limit: any(named: 'limit'),
            )).thenAnswer(
          (_) async => Left(CacheFailure('Database error')),
        );
        return dashboardBloc;
      },
      act: (bloc) => bloc.add(LoadDashboardData()),
      expect: () => [
        const DashboardState(status: DashboardStatus.loading),
        const DashboardState(
          status: DashboardStatus.error,
          errorMessage: 'Failure: Database error',
        ),
      ],
      verify: (_) {
        verify(() => mockTransactionUseCase.getTransactions(
              limit: 50,
            )).called(1);
      },
    );
  });
}
