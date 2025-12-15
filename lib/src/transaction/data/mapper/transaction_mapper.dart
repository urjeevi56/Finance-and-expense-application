import '../../domain/entities/transaction.dart';
import '../models/transaction_model.dart';

extension TransactionModelMapper on TransactionModel {
  Transaction toEntity() {
    return Transaction(
      id: id,
      title: title,
      amount: amount,
      category: category,
      date: date,
      type: type == TransactionTypeModel.income
          ? TransactionType.income
          : TransactionType.expense,
      description: description,
    );
  }
}

extension TransactionEntityMapper on Transaction {
  TransactionModel toModel() {
    return TransactionModel(
      id: id,
      title: title,
      amount: amount,
      category: category,
      date: date,
      type: type == TransactionType.income
          ? TransactionTypeModel.income
          : TransactionTypeModel.expense,
      description: description,
    );
  }
}
