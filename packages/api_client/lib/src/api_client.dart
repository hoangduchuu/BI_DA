import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String baseUrl = 'https://3f3d8a3a8bb0.ngrok-free.app/api/v1';
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';

  late final Dio _dio;
  late final SharedPreferences _prefs;

  ApiClient._() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
    _initPrefs();
  }

  static ApiClient? _instance;
  static ApiClient get instance {
    _instance ??= ApiClient._();
    return _instance!;
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _prefs.getString(tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Token expired, try to refresh
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the original request
              final token = _prefs.getString(tokenKey);
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              final response = await _dio.fetch(error.requestOptions);
              handler.resolve(response);
              return;
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = _prefs.getString(refreshTokenKey);
      if (refreshToken == null) return false;

      final response = await _dio.post('/auth/refresh', data: {
        'refreshToken': refreshToken,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        await _prefs.setString(tokenKey, data['accessToken']);
        await _prefs.setString(refreshTokenKey, data['refreshToken']);
        return true;
      }
    } catch (e) {
      // Refresh failed, clear tokens
      await _prefs.remove(tokenKey);
      await _prefs.remove(refreshTokenKey);
    }
    return false;
  }

  // Authentication
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'username': username,
      'password': password,
    });

    final data = response.data;
    await _prefs.setString(tokenKey, data['accessToken']);
    await _prefs.setString(refreshTokenKey, data['refreshToken']);

    return data;
  }

  Future<void> logout() async {
    await _prefs.remove(tokenKey);
    await _prefs.remove(refreshTokenKey);
  }

  // Companies
  Future<List<Map<String, dynamic>>> getCompanies() async {
    final response = await _dio.get('/companies');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<Map<String, dynamic>> createCompany(Map<String, dynamic> company) async {
    final response = await _dio.post('/companies', data: company);
    return response.data;
  }

  // Clubs
  Future<List<Map<String, dynamic>>> getClubs(int companyId) async {
    final response = await _dio.get('/companies/$companyId/clubs');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<Map<String, dynamic>> createClub(int companyId, Map<String, dynamic> club) async {
    final response = await _dio.post('/companies/$companyId/clubs', data: club);
    return response.data;
  }

  // Tables
  Future<List<Map<String, dynamic>>> getTables(int clubId, {String? status}) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;

    final response = await _dio.get('/clubs/$clubId/tables', queryParameters: queryParams);
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<Map<String, dynamic>> getTable(int tableId) async {
    final response = await _dio.get('/tables/$tableId');
    return response.data;
  }

  Future<Map<String, dynamic>> createTable(int clubId, Map<String, dynamic> table) async {
    final response = await _dio.post('/clubs/$clubId/tables', data: table);
    return response.data;
  }

  Future<Map<String, dynamic>> updateTable(int tableId, Map<String, dynamic> table) async {
    final response = await _dio.put('/tables/$tableId', data: table);
    return response.data;
  }

  // Bookings
  Future<List<Map<String, dynamic>>> getBookings(int tableId, {String? date}) async {
    final queryParams = <String, dynamic>{};
    if (date != null) queryParams['date'] = date;

    final response = await _dio.get('/tables/$tableId/bookings', queryParameters: queryParams);
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<Map<String, dynamic>> createBooking(int tableId, Map<String, dynamic> booking) async {
    final response = await _dio.post('/tables/$tableId/bookings', data: booking);
    return response.data;
  }

  // Orders
  Future<List<Map<String, dynamic>>> getOrders(int tableId, {String? status}) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;

    final response = await _dio.get('/tables/$tableId/orders', queryParameters: queryParams);
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<Map<String, dynamic>> createOrder(int tableId, Map<String, dynamic> order) async {
    final response = await _dio.post('/tables/$tableId/orders', data: order);
    return response.data;
  }

  // Bills
  Future<List<Map<String, dynamic>>> getBills(int tableId, {String? status}) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;

    final response = await _dio.get('/tables/$tableId/bills', queryParameters: queryParams);
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<Map<String, dynamic>> createBill(int tableId, Map<String, dynamic> bill) async {
    final response = await _dio.post('/tables/$tableId/bills', data: bill);
    return response.data;
  }

  // Utility methods
  bool get isAuthenticated => _prefs.getString(tokenKey) != null;

  String? get token => _prefs.getString(tokenKey);

  Future<void> clearTokens() async {
    await _prefs.remove(tokenKey);
    await _prefs.remove(refreshTokenKey);
  }
}
