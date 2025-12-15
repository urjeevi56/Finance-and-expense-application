import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:finanace_and_expense_app/src/transaction/domain/entities/transaction.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  static Future<void> exportToCSV(List<Transaction> transactions) async {
    final List<List<dynamic>> csvData = [];
    
 
    csvData.add([
      'Date',
      'Time',
      'Title',
      'Category',
      'Amount',
      'Type',
      'Description'
    ]);
    
    // Sort transactions by date
    transactions.sort((a, b) => b.date.compareTo(a.date));
    
    // Add data
    for (var transaction in transactions) {
      csvData.add([
        _formatDate(transaction.date),
        _formatTime(transaction.date),
        transaction.title,
        transaction.category,
        transaction.amount.toStringAsFixed(2),
        transaction.type == TransactionType.income ? 'Income' : 'Expense',
        transaction.description ?? '',
      ]);
    }
    
    
    final csv = const ListToCsvConverter().convert(csvData);
    
   
    final bytes = utf8.encode(csv);
    final fileName = 'transactions_${DateTime.now().millisecondsSinceEpoch}.csv';
    
  
    final xFile = XFile.fromData(
      Uint8List.fromList(bytes),
      name: fileName,
      mimeType: 'text/csv',
    );
    
    await Share.shareXFiles([xFile]);
  }
  
  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
  
  static String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
  
  static Future<String> generateCSVContent(List<Transaction> transactions) async {
    final List<List<dynamic>> csvData = [];
    
    csvData.add([
      'Date',
      'Time',
      'Title',
      'Category',
      'Amount',
      'Type',
      'Description'
    ]);
    
    transactions.sort((a, b) => b.date.compareTo(a.date));
    
    for (var transaction in transactions) {
      csvData.add([
        _formatDate(transaction.date),
        _formatTime(transaction.date),
        transaction.title,
        transaction.category,
        transaction.amount.toStringAsFixed(2),
        transaction.type == TransactionType.income ? 'Income' : 'Expense',
        transaction.description ?? '',
      ]);
    }
    
    return const ListToCsvConverter().convert(csvData);
  }
}