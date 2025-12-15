import 'package:finanace_and_expense_app/src/transaction/data/models/transaction_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String transactionBoxName = 'transactions';
  static const String budgetBoxName = 'budgets';
  static const String settingsBoxName = 'settings';
  
  static Future<void> init() async {
    await Hive.initFlutter();
    
    
    Hive.registerAdapter(TransactionModelAdapter());

    await Hive.openBox<TransactionModel>(transactionBoxName);
    await Hive.openBox(budgetBoxName);
    await Hive.openBox(settingsBoxName);
  }
  
  static Box<TransactionModel> get transactionBox => 
      Hive.box<TransactionModel>(transactionBoxName);
  
  static Box get budgetBox => Hive.box(budgetBoxName);
  
  static Box get settingsBox => Hive.box(settingsBoxName);
  
  static Future<void> clearAll() async {
    await transactionBox.clear();
    await budgetBox.clear();
    await settingsBox.clear();
  }
  
  static Future<void> close() async {
    await Hive.close();
  }
}