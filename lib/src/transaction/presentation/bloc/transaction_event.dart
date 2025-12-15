import 'package:equatable/equatable.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/entities/transaction.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class LoadTransactions extends TransactionEvent {
  final int limit;
  
  const LoadTransactions({this.limit = 50});
}

class AddTransactionEvent extends TransactionEvent {
  final Transaction transaction;
  
  const AddTransactionEvent(this.transaction);
}

class UpdateTransactionEvent extends TransactionEvent {
  final Transaction transaction;
  
  const UpdateTransactionEvent(this.transaction);
}

class DeleteTransactionEvent extends TransactionEvent {
  final String id;
  
  const DeleteTransactionEvent(this.id);
}

class FilterTransactions extends TransactionEvent {
  final String? category;
  final DateTime? startDate;
  final DateTime? endDate;
  
  const FilterTransactions({
    this.category,
    this.startDate,
    this.endDate,
  });
}

class ExportTransactions extends TransactionEvent {}