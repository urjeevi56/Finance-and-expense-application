import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:finanace_and_expense_app/core/error/failures.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/entities/transaction.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/usecase/transaction_usecase.dart';
import 'package:finanace_and_expense_app/src/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:finanace_and_expense_app/src/transaction/presentation/bloc/transaction_event.dart';
import 'package:finanace_and_expense_app/src/transaction/presentation/bloc/transaction_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionUseCase extends Mock
    implements TransactionUseCase {}

class FakeTransaction extends Fake implements Transaction {}

void main() {
  late MockTransactionUseCase mockTransactionUseCase;
  late TransactionBloc transactionBloc;

  setUpAll(() {
    registerFallbackValue(FakeTransaction());
  });

  final testTransaction = Transaction(
    id: '1',
    title: 'Food',
    amount: 100.0,
    category: 'Food',
    date: DateTime(2024, 1, 1),
    type: TransactionType.expense,
  );

  final testTransactions = [testTransaction];

  setUp(() {
    mockTransactionUseCase = MockTransactionUseCase();
    transactionBloc = TransactionBloc(
      transactionUseCase: mockTransactionUseCase,
    );
  });

  tearDown(() {
    transactionBloc.close();
  });

  group('TransactionBloc', () {
    test('initial state is TransactionState.initial', () {
      expect(transactionBloc.state, const TransactionState());
    });

    blocTest<TransactionBloc, TransactionState>(
      'emits [loading, success] when LoadTransactions succeeds',
      build: () {
        when(() => mockTransactionUseCase.getTransactions(
              limit: any(named: 'limit'),
            )).thenAnswer((_) async => Right(testTransactions));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(const LoadTransactions()),
      expect: () => [
        const TransactionState(status: TransactionStatus.loading),
        TransactionState(
          status: TransactionStatus.success,
          transactions: testTransactions,
          categories: const ['Food'],
        ),
      ],
      verify: (_) {
        verify(() => mockTransactionUseCase.getTransactions(
              limit: any(named: 'limit'),
            )).called(1);
      },
    );

    blocTest<TransactionBloc, TransactionState>(
      'emits [loading, error] when LoadTransactions fails',
      build: () {
        when(() => mockTransactionUseCase.getTransactions(
              limit: any(named: 'limit'),
            )).thenAnswer(
          (_) async => Left(CacheFailure('Database error')),
        );
        return transactionBloc;
      },
      act: (bloc) => bloc.add(const LoadTransactions()),
      expect: () => [
        const TransactionState(status: TransactionStatus.loading),
        const TransactionState(
          status: TransactionStatus.error,
          errorMessage: 'Failure: Database error',
        ),
      ],
    );

    blocTest<TransactionBloc, TransactionState>(
      'adds transaction and reloads transactions',
      build: () {
        when(() => mockTransactionUseCase.addTransaction(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockTransactionUseCase.getTransactions(
              limit: any(named: 'limit'),
            )).thenAnswer((_) async => Right(testTransactions));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(AddTransactionEvent(testTransaction)),
      verify: (_) {
        verify(() => mockTransactionUseCase.addTransaction(testTransaction))
            .called(1);
        verify(() => mockTransactionUseCase.getTransactions(
              limit: any(named: 'limit'),
            )).called(1);
      },
    );

    blocTest<TransactionBloc, TransactionState>(
      'updates transaction and reloads transactions',
      build: () {
        when(() => mockTransactionUseCase.updateTransaction(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockTransactionUseCase.getTransactions(
              limit: any(named: 'limit'),
            )).thenAnswer((_) async => Right(testTransactions));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(UpdateTransactionEvent(testTransaction)),
      verify: (_) {
        verify(() => mockTransactionUseCase.updateTransaction(testTransaction))
            .called(1);
      },
    );

    blocTest<TransactionBloc, TransactionState>(
      'deletes transaction and reloads transactions',
      build: () {
        when(() => mockTransactionUseCase.deleteTransaction(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockTransactionUseCase.getTransactions(
              limit: any(named: 'limit'),
            )).thenAnswer((_) async => Right(testTransactions));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(const DeleteTransactionEvent('1')),
      verify: (_) {
        verify(() => mockTransactionUseCase.deleteTransaction('1')).called(1);
      },
    );
  });
}
