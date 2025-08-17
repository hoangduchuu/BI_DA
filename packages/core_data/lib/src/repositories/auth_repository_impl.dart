import 'package:core_domain/core_domain.dart';
import '../network/api_client.dart';
import '../storage/token_storage.dart';
import '../exceptions/data_exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl({
    required ApiClient apiClient,
    required TokenStorage tokenStorage,
  })  : _apiClient = apiClient,
        _tokenStorage = tokenStorage;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: request.toJson(),
      );

      if (response.data == null) {
        throw const DataException('Login failed: No response data');
      }

      final loginResponse = LoginResponse.fromJson(response.data!);

      // Save tokens to secure storage
      await _tokenStorage.saveTokens(
        accessToken: loginResponse.accessToken,
        refreshToken: loginResponse.refreshToken,
        userId: loginResponse.userId,
        username: loginResponse.username,
        role: loginResponse.role,
        companyId: loginResponse.companyId,
        clubId: loginResponse.clubId,
      );

      return loginResponse;
    } catch (e) {
      if (e is DataException) rethrow;
      throw AuthException('Login failed: ${e.toString()}', originalException: e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Call logout endpoint if available
      await _apiClient.post('/auth/logout');
    } catch (e) {
      // Continue with local logout even if server logout fails
    } finally {
      // Always clear local tokens
      await _tokenStorage.clearTokens();
    }
  }

  @override
  Future<LoginResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.data == null) {
        throw const DataException('Token refresh failed: No response data');
      }

      final loginResponse = LoginResponse.fromJson(response.data!);

      // Update stored tokens
      await _tokenStorage.saveTokens(
        accessToken: loginResponse.accessToken,
        refreshToken: loginResponse.refreshToken,
        userId: loginResponse.userId,
        username: loginResponse.username,
        role: loginResponse.role,
        companyId: loginResponse.companyId,
        clubId: loginResponse.clubId,
      );

      return loginResponse;
    } catch (e) {
      // Clear tokens on refresh failure
      await _tokenStorage.clearTokens();
      if (e is DataException) rethrow;
      throw AuthException('Token refresh failed: ${e.toString()}', originalException: e);
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/users/me',
      );

      if (response.data == null) return null;

      return User.fromJson(response.data!);
    } catch (e) {
      if (e is AuthException) {
        // Clear tokens if user fetch fails due to auth
        await _tokenStorage.clearTokens();
      }
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final hasToken = await _tokenStorage.hasValidToken();
    if (!hasToken) return false;

    // Optionally verify token with server
    try {
      final user = await getCurrentUser();
      return user != null;
    } catch (e) {
      return false;
    }
  }
}
