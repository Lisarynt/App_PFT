import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction_model.dart';

class TransactionApiService {
  static const String baseUrl =
      'https://6944ef007dd335f4c361abcf.mockapi.io/transactions';

  // GET
  Future<List<TransactionModel>> getTransactions(String userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl?userId=$userId'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => TransactionModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil transaksi');
    }
  }

  // CREATE
  Future<void> addTransaction(TransactionModel transaction) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(transaction.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal menambah transaksi');
    }
  }

  // UPDATE
  Future<void> updateTransaction(String id, TransactionModel transaction) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(transaction.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal update transaksi');
    }
  }

  // DELETE
  Future<void> deleteTransaction(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal hapus transaksi');
    }
  }
}
