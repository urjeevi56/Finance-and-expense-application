import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:finanace_and_expense_app/core/error/failures.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/entities/transaction.dart';
import 'package:finanace_and_expense_app/src/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:finanace_and_expense_app/src/transaction/presentation/bloc/transaction_event.dart';
import 'package:finanace_and_expense_app/src/transaction/presentation/bloc/transaction_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTransactions extends Mock implements GetTransactions {}
class MockAddTransaction extends Mock implements AddTransaction {}
class MockUpdateTransaction extends Mock implements UpdateTransaction {}
class MockDeleteTransaction extends Mock implements DeleteTransaction {}

void main() {
  late MockGetTransactions mockGetTransactions;
  late MockAddTransaction mockAddTransaction;
  late MockUpdateTransaction mockUpdateTransaction;
  late MockDeleteTransaction mockDeleteTransaction;
  late TransactionBloc transactionBloc;
  
  final testTransaction = Transaction(
    id: '1',
    title: 'Test Transaction',
    amount: 100.0,
    category: 'Food',
    date: DateTime(2024, 1, 1),
    type: TransactionType.expense,
  );
  
  final testTransactions = [testTransaction];
  
  setUp(() {
    mockGetTransactions = MockGetTransactions();
    mockAddTransaction = MockAddTransaction();
    mockUpdateTransaction = MockUpdateTransaction();
    mockDeleteTransaction = MockDeleteTransaction();
    
    transactionBloc = TransactionBloc(
      getTransactions: mockGetTransactions,
      addTransaction: mockAddTransaction,
      updateTransaction: mockUpdateTransaction,
      deleteTransaction: mockDeleteTransaction, transactionUseCase: null,
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
      'emits [loading, success] when LoadTransactions is successful',
      build: () {
        when(() => mockGetTransactions.call(any()))
            .thenAnswer((_) async => Right(testTransactions));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(const LoadTransactions()),
      expect: () => [
        const TransactionState(status: TransactionStatus.loading),
        TransactionState(
          status: TransactionStatus.success,
          transactions: testTransactions,
          categories: ['Food'],
        ),
      ],
    );
    
    blocTest<TransactionBloc, TransactionState>(
      'emits [loading, error] when LoadTransactions fails',
      build: () {
        when(() => mockGetTransactions.call(any()))
            .thenAnswer((_) async => Left(CacheFailure('Database error')));
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
      'calls AddTransaction use case and reloads transactions',
      build: () {
        when(() => mockAddTransaction.call(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockGetTransactions.call(any()))
            .thenAnswer((_) async => Right(testTransactions));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(AddTransactionEvent(testTransaction)),
      verify: (_) {
        verify(() => mockAddTransaction.call(testTransaction as int)).called(1);
        verify(() => mockGetTransactions.call(any())).called(1);
      },
    );
    
    blocTest<TransactionBloc, TransactionState>(
      'calls UpdateTransaction use case and reloads transactions',
      build: () {
        when(() => mockUpdateTransaction.call(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockGetTransactions.call(any()))
            .thenAnswer((_) async => Right(testTransactions));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(UpdateTransactionEvent(testTransaction)),
      verify: (_) {
        verify(() => mockUpdateTransaction.call(testTransaction as int)).called(1);
        verify(() => mockGetTransactions.call(any())).called(1);
      },
    );
    
    blocTest<TransactionBloc, TransactionState>(
      'calls DeleteTransaction use case and reloads transactions',
      build: () {
        when(() => mockDeleteTransaction.call(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockGetTransactions.call(any()))
            .thenAnswer((_) async => Right(testTransactions));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(const DeleteTransactionEvent('1')),
      verify: (_) {
        verify(() => mockDeleteTransaction.call('1' as int)).called(1);
        verify(() => mockGetTransactions.call(any())).called(1);
      },
    );
  });
}