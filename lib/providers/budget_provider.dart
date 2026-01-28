import 'package:flutter/material.dart';
import '../models/budget_model.dart';
import '../services/budget_api_service.dart';

class BudgetProvider extends ChangeNotifier {
  final BudgetApiService _apiService = BudgetApiService();

  List<BudgetModel> _budgets = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<BudgetModel> get budgets => _budgets;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// GET budgets
  Future<void> getBudgets(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      print('Fetching budgets for userId: $userId'); // DEBUG
      _budgets = await _apiService.getBudgets(userId);
      _errorMessage = null;
      print('Budgets loaded: ${_budgets.length}'); // DEBUG
    } catch (e) {
      _errorMessage = e.toString();
      print('GetBudgets Error: $_errorMessage');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// ADD budget
  Future<bool> addBudget(BudgetModel budget, String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final budgetWithUserId = BudgetModel(
        id: budget.id,
        userId: userId, // Dari akun yang login
        category: budget.category,
        amount: budget.amount,
        period: budget.period,
        startDate: budget.startDate,
        endDate: budget.endDate,
      );
      await _apiService.addBudget(budgetWithUserId);
      await getBudgets(userId); // refresh data
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      print('AddBudget Error: $_errorMessage');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// UPDATE budget
  Future<bool> updateBudget(
    String id,
    BudgetModel budget,
    String userId,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.updateBudget(id, budget);
      await getBudgets(userId); // refresh data
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// DELETE budget
  Future<bool> deleteBudget(String id, String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.deleteBudget(id);
      await getBudgets(userId); // refresh data
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get by category
  BudgetModel? getBudgetByCategory(String category, String userId) {
    try {
      return _budgets.firstWhere(
        (b) => b.category == category && b.userId == userId,
      );
    } catch (_) {
      return null;
    }
  }


  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
