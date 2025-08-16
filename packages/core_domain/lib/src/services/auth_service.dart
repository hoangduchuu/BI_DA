import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';

  static AuthService? _instance;
  static AuthService get instance {
    _instance ??= AuthService._();
    return _instance!;
  }

  AuthService._();

  late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Login
  Future<bool> login(String username, String password) async {
    try {
      // TODO: Replace with actual API call
      // For now, simulate successful login
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock response
      const mockToken = 'mock_jwt_token_12345';
      const mockRefreshToken = 'mock_refresh_token_67890';
      final mockUser = {
        'id': 1,
        'username': username,
        'email': '$username@example.com',
        'role': 'STAFF',
        'companyId': 1,
        'clubId': 1,
      };

      await _prefs.setString(_tokenKey, mockToken);
      await _prefs.setString(_refreshTokenKey, mockRefreshToken);
      await _prefs.setString(_userKey, mockUser.toString());

      return true;
    } catch (e) {
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userKey);
  }

  // Check if user is authenticated
  bool get isAuthenticated {
    final token = _prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  // Get current token
  String? get token => _prefs.getString(_tokenKey);

  // Get refresh token
  String? get refreshToken => _prefs.getString(_refreshTokenKey);

  // Get user data
  Map<String, dynamic>? get userData {
    final userStr = _prefs.getString(_userKey);
    if (userStr == null) return null;
    
    try {
      // Simple parsing for mock data
      final cleanStr = userStr.replaceAll('{', '').replaceAll('}', '');
      final pairs = cleanStr.split(',');
      final map = <String, dynamic>{};
      
      for (final pair in pairs) {
        final keyValue = pair.trim().split(':');
        if (keyValue.length == 2) {
          final key = keyValue[0].trim().replaceAll("'", '');
          final value = keyValue[1].trim().replaceAll("'", '');
          map[key] = value;
        }
      }
      
      return map;
    } catch (e) {
      return null;
    }
  }

  // Get user role
  String? get userRole => userData?['role'];

  // Get company ID
  int? get companyId {
    final id = userData?['companyId'];
    return id != null ? int.tryParse(id.toString()) : null;
  }

  // Get club ID
  int? get clubId {
    final id = userData?['clubId'];
    return id != null ? int.tryParse(id.toString()) : null;
  }

  // Check if user has specific role
  bool hasRole(String role) {
    return userRole == role;
  }

  // Check if user is admin
  bool get isAdmin => hasRole('OWNER') || hasRole('CLUB_MANAGER');

  // Check if user is staff
  bool get isStaff => hasRole('STAFF');

  // Check if user is customer
  bool get isCustomer => hasRole('CUSTOMER');
}
