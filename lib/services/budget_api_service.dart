import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/budget_model.dart';

class BudgetApiService {
  static const String baseUrl =
      'https://6944ef007dd335f4c361abcf.mockapi.io/budgets';

  // GET
  Future<List<BudgetModel>> getBudgets(String userId) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((e) => BudgetModel.fromJson(e))
          .where((b) => b.userId == userId)
          .toList();
    } else {
      throw Exception('Gagal mengambil budget');
    }
  }


  // CREATE
  Future<void> addBudget(BudgetModel budget) async {
    final body = budget.toJson();
    
    print('Adding budget with userId: ${budget.userId}'); // DEBUG
    print('Request body: $body'); // DEBUG

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print('Response status: ${response.statusCode}'); // DEBUG
    print('Response body: ${response.body}'); // DEBUG

    if (response.statusCode != 201) {
      throw Exception('Gagal menambah budget: ${response.body}');
    }
  }

  // UPDATE
  Future<void> updateBudget(String id, BudgetModel budget) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(budget.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal update budget');
    }
  }

  // DELETE
  Future<void> deleteBudget(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal hapus budget');
    }
  }
}
