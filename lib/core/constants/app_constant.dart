import 'package:finanace_and_expense_app/src/budgets/presentation/screens/budget_screen.dart';
import 'package:finanace_and_expense_app/src/transaction/presentation/screens/add_edit_transaction_screen.dart';
import 'package:finanace_and_expense_app/src/transaction/presentation/screens/transaction_screen.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Smart Finance Tracker';
  static const String currencySymbol = '₹';

  static const List<String> categories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Healthcare',
    'Education',
    'Investment',
    'Salary',
    'Other',
  ];

  static const Map<String, Color> categoryColors = {
    'Food': Color(0xFFFF6B6B),
    'Transport': Color(0xFF4ECDC4),
    'Shopping': Color(0xFFFFD166),
    'Entertainment': Color(0xFF06D6A0),
    'Bills': Color(0xFF118AB2),
    'Healthcare': Color(0xFFEF476F),
    'Education': Color(0xFF7209B7),
    'Investment': Color(0xFF3A86FF),
    'Salary': Color(0xFF38B000),
    'Other': Color(0xFF6C757D),
  };

  static final Map<String, WidgetBuilder> routes = {
    '/transactions': (context) => const TransactionsScreen(),
    '/add-transaction': (context) => const AddEditTransactionScreen(),
    '/edit-transaction': (context) => const AddEditTransactionScreen(),
    '/budgets': (context) => const BudgetsScreen(),
  };
}

