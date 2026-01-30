import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_api_service.dart';
import '../utils/helpers.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionApiService _apiService = TransactionApiService();

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  // GETTERS
  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // GET
  Future<void> getTransactions(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await _apiService.getTransactions(userId);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // CREATE
  Future<bool> addTransaction(TransactionModel transaction) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.addTransaction(transaction);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // UPDATE
  Future<bool> updateTransaction(String id, TransactionModel transaction) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.updateTransaction(id, transaction);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // DELETE
  Future<bool> deleteTransaction(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteTransaction(id);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CALCULATION

  double getTotalIncome() {
    return _transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getTotalExpense() {
    return _transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getBalance() {
    return getTotalIncome() - getTotalExpense();
  }

  List<TransactionModel> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return _transactions.where((t) {
      return t.date.isAfter(start.subtract(const Duration(days: 1))) &&
          t.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  List<TransactionModel> getCurrentMonthTransactions() {
    final range = Helpers.getCurrentMonthRange();
    return getTransactionsByDateRange(
      range['start']!,
      range['end']!,
    );
  }

  // CATEGORY REPORT

// Total pengeluaran per kategori
Map<String, double> getSpendingByCategory() {
  final Map<String, double> spending = {};

  for (final t in _transactions.where((t) => t.type == 'expense')) {
    spending[t.category] =
        (spending[t.category] ?? 0) + t.amount;
  }

  return spending;
}

// Total pemasukan per kategori
Map<String, double> getIncomeByCategory() {
  final Map<String, double> income = {};

  for (final t in _transactions.where((t) => t.type == 'income')) {
    income[t.category] =
        (income[t.category] ?? 0) + t.amount;
  }

  return income;
}


  // UTILS

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
