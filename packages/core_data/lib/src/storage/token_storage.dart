import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _roleKey = 'role';
  static const String _companyIdKey = 'company_id';
  static const String _clubIdKey = 'club_id';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String username,
    required String role,
    required String companyId,
    String? clubId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(_accessTokenKey, accessToken),
      prefs.setString(_refreshTokenKey, refreshToken),
      prefs.setString(_userIdKey, userId),
      prefs.setString(_usernameKey, username),
      prefs.setString(_roleKey, role),
      prefs.setString(_companyIdKey, companyId),
      if (clubId != null) prefs.setString(_clubIdKey, clubId),
    ]);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  Future<String?> getCompanyId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_companyIdKey);
  }

  Future<String?> getClubId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_clubIdKey);
  }

  Future<bool> hasValidToken() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_accessTokenKey),
      prefs.remove(_refreshTokenKey),
      prefs.remove(_userIdKey),
      prefs.remove(_usernameKey),
      prefs.remove(_roleKey),
      prefs.remove(_companyIdKey),
      prefs.remove(_clubIdKey),
    ]);
  }
}
