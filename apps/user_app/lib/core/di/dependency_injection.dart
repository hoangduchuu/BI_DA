import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';

class DependencyInjection {
  static late final TokenStorage _tokenStorage;
  static late final ApiClient _apiClient;
  static late final AuthRepository _authRepository;
  static late final UserRepository _userRepository;
  static late final CompanyRepository _companyRepository;

  static bool _initialized = false;

  static Future<void> initialize({
    String baseUrl = 'http://localhost:8080',
  }) async {
    if (_initialized) return;

    // Initialize storage
    _tokenStorage = TokenStorage();

    // Initialize API client
    _apiClient = ApiClient(
      baseUrl: baseUrl,
      tokenStorage: _tokenStorage,
    );

    // Initialize repositories
    _authRepository = AuthRepositoryImpl(
      apiClient: _apiClient,
      tokenStorage: _tokenStorage,
    );

    _userRepository = UserRepositoryImpl(apiClient: _apiClient);
    _companyRepository = CompanyRepositoryImpl(apiClient: _apiClient);

    _initialized = true;
  }

  // Getters for dependency access
  static TokenStorage get tokenStorage {
    _ensureInitialized();
    return _tokenStorage;
  }

  static ApiClient get apiClient {
    _ensureInitialized();
    return _apiClient;
  }

  static AuthRepository get authRepository {
    _ensureInitialized();
    return _authRepository;
  }

  static UserRepository get userRepository {
    _ensureInitialized();
    return _userRepository;
  }

  static CompanyRepository get companyRepository {
    _ensureInitialized();
    return _companyRepository;
  }

  static void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('DependencyInjection not initialized. Call initialize() first.');
    }
  }
}
