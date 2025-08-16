import 'package:core_domain/core_domain.dart';
import '../network/api_client.dart';
import '../exceptions/data_exceptions.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiClient _apiClient;

  UserRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<User>> getUsers() async {
    try {
      final response = await _apiClient.get<List<dynamic>>('/api/v1/users');

      if (response.data == null) {
        throw const DataException('Failed to fetch users: No response data');
      }

      return response.data!
          .cast<Map<String, dynamic>>()
          .map((json) => User.fromJson(json))
          .toList();
    } catch (e) {
      if (e is DataException) rethrow;
      throw DataException('Failed to fetch users: ${e.toString()}', originalException: e);
    }
  }

  @override
  Future<User> getUserById(String id) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>('/api/v1/users/$id');

      if (response.data == null) {
        throw NotFoundException('User not found: $id');
      }

      return User.fromJson(response.data!);
    } catch (e) {
      if (e is DataException) rethrow;
      throw DataException('Failed to fetch user: ${e.toString()}', originalException: e);
    }
  }

  @override
  Future<User> createUser(CreateUserRequest request) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/v1/users/create',
        data: request.toJson(),
      );

      if (response.data == null) {
        throw const DataException('Failed to create user: No response data');
      }

      return User.fromJson(response.data!);
    } catch (e) {
      if (e is DataException) rethrow;
      throw DataException('Failed to create user: ${e.toString()}', originalException: e);
    }
  }

  @override
  Future<User> updateUser(String id, Map<String, dynamic> updates) async {
    try {
      final response = await _apiClient.put<Map<String, dynamic>>(
        '/api/v1/users/$id',
        data: updates,
      );

      if (response.data == null) {
        throw const DataException('Failed to update user: No response data');
      }

      return User.fromJson(response.data!);
    } catch (e) {
      if (e is DataException) rethrow;
      throw DataException('Failed to update user: ${e.toString()}', originalException: e);
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await _apiClient.delete('/api/v1/users/$id');
    } catch (e) {
      if (e is DataException) rethrow;
      throw DataException('Failed to delete user: ${e.toString()}', originalException: e);
    }
  }
}
