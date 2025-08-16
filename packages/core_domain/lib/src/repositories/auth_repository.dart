import '../models/auth_models.dart';
import '../models/user.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest request);
  Future<void> logout();
  Future<LoginResponse> refreshToken(String refreshToken);
  Future<User?> getCurrentUser();
  Future<bool> isAuthenticated();
}

abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User> getUserById(String id);
  Future<User> createUser(CreateUserRequest request);
  Future<User> updateUser(String id, Map<String, dynamic> updates);
  Future<void> deleteUser(String id);
}
