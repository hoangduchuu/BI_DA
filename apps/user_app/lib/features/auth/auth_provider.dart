import 'package:flutter/foundation.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_data/core_data.dart';
import '../../core/di/dependency_injection.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthState _state = AuthState.initial;
  User? _user;
  String? _errorMessage;

  // Getters
  AuthState get state => _state;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isLoading => _state == AuthState.loading;

  // Initialize and check existing authentication
  Future<void> initialize() async {
    _setState(AuthState.loading);
    
    try {
      final authRepo = DependencyInjection.authRepository;
      final isAuth = await authRepo.isAuthenticated();
      
      if (isAuth) {
        _user = await authRepo.getCurrentUser();
        _setState(AuthState.authenticated);
      } else {
        _setState(AuthState.unauthenticated);
      }
    } catch (e) {
      _setError('Failed to initialize authentication: ${e.toString()}');
    }
  }

  // Login method
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _setState(AuthState.loading);
    
    try {
      final authRepo = DependencyInjection.authRepository;
      final loginRequest = LoginRequest(
        username: username,
        password: password,
      );
      
      await authRepo.login(loginRequest);
      _user = await authRepo.getCurrentUser();
      
      _setState(AuthState.authenticated);
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } on ValidationException catch (e) {
      _setError('Invalid credentials: ${e.message}');
      return false;
    } on NetworkException catch (e) {
      _setError('Network error: ${e.message}');
      return false;
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    _setState(AuthState.loading);
    
    try {
      final authRepo = DependencyInjection.authRepository;
      await authRepo.logout();
    } catch (e) {
      // Continue with logout even if server call fails
      debugPrint('Logout error: ${e.toString()}');
    } finally {
      _user = null;
      _setState(AuthState.unauthenticated);
    }
  }

  // Refresh user data
  Future<void> refreshUser() async {
    if (_state != AuthState.authenticated) return;
    
    try {
      final authRepo = DependencyInjection.authRepository;
      _user = await authRepo.getCurrentUser();
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to refresh user: ${e.toString()}');
    }
  }

  // Private helper methods
  void _setState(AuthState newState) {
    _state = newState;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _state = AuthState.error;
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    if (_state == AuthState.error) {
      _setState(_user != null ? AuthState.authenticated : AuthState.unauthenticated);
    }
  }
}
