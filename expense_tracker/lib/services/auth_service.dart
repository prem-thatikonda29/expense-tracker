import '../models/user.dart';
import '../services/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<bool> tryAutoLogin() async {
    final token = await _apiService.getToken();
    if (token == null) {
      return false;
    }
    await _apiService.setToken(
      token,
    ); // Ensure api service has token set if it needs it internally
    return true;
  }

  Future<User> login(String email, String password) async {
    try {
      final response = await _apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });
      final token = response['token'];
      await _apiService.setToken(token);
      return await fetchUserProfile();
    } catch (e) {
      rethrow;
    }
  }

  Future<User> signup(String email, String password) async {
    try {
      final response = await _apiService.post('/auth/signup', {
        'email': email,
        'password': password,
      });
      final token = response['token'];
      await _apiService.setToken(token);
      return await fetchUserProfile();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _apiService.removeToken();
  }

  Future<User> fetchUserProfile() async {
    try {
      final response = await _apiService.get('/user/profile');
      return User.fromJson(response);
    } catch (e) {
      // debugPrint('Error fetching profile: $e'); // Or use a logger
      rethrow;
    }
  }
}
