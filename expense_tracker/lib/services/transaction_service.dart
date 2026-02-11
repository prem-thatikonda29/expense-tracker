import '../models/transaction.dart';
import '../services/api_service.dart';

class TransactionService {
  final ApiService _apiService = ApiService();

  Future<List<Transaction>> fetchTransactions() async {
    try {
      final response = await _apiService.get('/transactions');
      final List<dynamic> data = response as List<dynamic>;
      return data.map((item) => Transaction.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> addTransaction(Transaction transaction) async {
    try {
      final response = await _apiService.post(
        '/transactions',
        transaction.toJson(),
      );
      return Transaction.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> updateTransaction(
    String id,
    Transaction transaction,
  ) async {
    try {
      final response = await _apiService.put(
        '/transactions/$id',
        transaction.toJson(),
      );
      return Transaction.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _apiService.delete('/transactions/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchSummary(String period) async {
    try {
      final response = await _apiService.get(
        '/transactions/summary?period=$period',
      );
      return response as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, double>> fetchCategorySpending() async {
    try {
      final response = await _apiService.get('/transactions/category-spending');
      return Map<String, double>.from(
        (response as Map).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
