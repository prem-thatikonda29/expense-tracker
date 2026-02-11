import '../services/api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<void> updateMonthlyBudget(double amount) async {
    try {
      await _apiService.put('/user/budget', {'monthlyBudget': amount});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCategoryBudgets(
    Map<String, double> categoryBudgets,
  ) async {
    try {
      await _apiService.put('/user/category-budgets', {
        'categoryBudgets': categoryBudgets,
      });
    } catch (e) {
      rethrow;
    }
  }
}
