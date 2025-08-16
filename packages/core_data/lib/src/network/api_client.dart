import 'package:dio/dio.dart';
import '../storage/token_storage.dart';
import '../exceptions/data_exceptions.dart';

class ApiClient {
  late final Dio _dio;
  final TokenStorage _tokenStorage;
  final String baseUrl;

  ApiClient({
    required this.baseUrl,
    required TokenStorage tokenStorage,
  }) : _tokenStorage = tokenStorage {
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
  }

  void _setupInterceptors() {
    // Request interceptor - Add auth token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _tokenStorage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Try to refresh token
          final refreshToken = await _tokenStorage.getRefreshToken();
          if (refreshToken != null) {
            try {
              // Implement token refresh logic here
              // For now, just clear tokens and throw auth exception
              await _tokenStorage.clearTokens();
            } catch (e) {
              await _tokenStorage.clearTokens();
            }
          }
        }
        handler.next(error);
      },
    ));

    // Logging interceptor (only in debug mode)
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  DataException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          'Connection timeout. Please check your internet connection.',
          originalException: error,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? error.message;

        switch (statusCode) {
          case 400:
            return ValidationException(
              message ?? 'Invalid request data',
              code: '400',
              originalException: error,
            );
          case 401:
            return AuthException(
              'Authentication failed. Please log in again.',
              code: '401',
              originalException: error,
            );
          case 403:
            return AuthException(
              'Access denied. You don\'t have permission to perform this action.',
              code: '403',
              originalException: error,
            );
          case 404:
            return NotFoundException(
              'The requested resource was not found.',
              code: '404',
              originalException: error,
            );
          case 500:
          default:
            return DataException(
              message ?? 'Server error. Please try again later.',
              code: statusCode?.toString(),
              originalException: error,
            );
        }
      case DioExceptionType.cancel:
        return DataException(
          'Request was cancelled',
          originalException: error,
        );
      case DioExceptionType.unknown:
      default:
        return NetworkException(
          'Network error. Please check your internet connection.',
          originalException: error,
        );
    }
  }
}
