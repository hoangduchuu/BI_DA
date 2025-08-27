/// Centralized API configuration for the BI_DA project
/// 
/// This file contains all API endpoint configurations in one place
/// for easy management and updates across all Flutter apps.
class ApiConfig {
  // =============================================================================
  // BASE CONFIGURATION
  // =============================================================================
  
  /// Base URL for the API server
  /// Update this single URL to change endpoints for all apps
  static const String baseUrl = 'https://d101f949f9dd.ngrok-free.app/api/v1';
  
  /// API version
  static const String apiVersion = 'v1';
  
  /// Connection timeout in seconds
  static const int connectTimeoutSeconds = 30;
  
  /// Receive timeout in seconds
  static const int receiveTimeoutSeconds = 30;
  
  // =============================================================================
  // AUTHENTICATION ENDPOINTS
  // =============================================================================
  
  /// Login endpoint
  static String get loginUrl => '$baseUrl/auth/login';
  
  /// Logout endpoint
  static String get logoutUrl => '$baseUrl/auth/logout';
  
  /// Refresh token endpoint
  static String get refreshTokenUrl => '$baseUrl/auth/refresh';
  
  /// Register endpoint
  static String get registerUrl => '$baseUrl/auth/register';
  
  /// Forgot password endpoint
  static String get forgotPasswordUrl => '$baseUrl/auth/forgot-password';
  
  /// Reset password endpoint
  static String get resetPasswordUrl => '$baseUrl/auth/reset-password';
  
  // =============================================================================
  // COMPANY ENDPOINTS
  // =============================================================================
  
  /// Get all companies
  static String get companiesUrl => '$baseUrl/companies';
  
  /// Get company by ID
  static String companyUrl(int companyId) => '$baseUrl/companies/$companyId';
  
  /// Create company
  static String get createCompanyUrl => '$baseUrl/companies';
  
  /// Update company
  static String updateCompanyUrl(int companyId) => '$baseUrl/companies/$companyId';
  
  /// Delete company
  static String deleteCompanyUrl(int companyId) => '$baseUrl/companies/$companyId';
  
  // =============================================================================
  // CLUB ENDPOINTS
  // =============================================================================
  
  /// Get clubs for a company
  static String clubsUrl(int companyId) => '$baseUrl/companies/$companyId/clubs';
  
  /// Get club by ID
  static String clubUrl(int clubId) => '$baseUrl/clubs/$clubId';
  
  /// Create club
  static String createClubUrl(int companyId) => '$baseUrl/companies/$companyId/clubs';
  
  /// Update club
  static String updateClubUrl(int clubId) => '$baseUrl/clubs/$clubId';
  
  /// Delete club
  static String deleteClubUrl(int clubId) => '$baseUrl/clubs/$clubId';
  
  // =============================================================================
  // TABLE ENDPOINTS
  // =============================================================================
  
  /// Get tables for a club
  static String tablesUrl(int clubId) => '$baseUrl/clubs/$clubId/tables';
  
  /// Get table by ID
  static String tableUrl(int tableId) => '$baseUrl/tables/$tableId';
  
  /// Create table
  static String createTableUrl(int clubId) => '$baseUrl/clubs/$clubId/tables';
  
  /// Update table
  static String updateTableUrl(int tableId) => '$baseUrl/tables/$tableId';
  
  /// Delete table
  static String deleteTableUrl(int tableId) => '$baseUrl/tables/$tableId';
  
  /// Update table status
  static String updateTableStatusUrl(int tableId) => '$baseUrl/tables/$tableId/status';
  
  // =============================================================================
  // BOOKING ENDPOINTS
  // =============================================================================
  
  /// Get bookings for a table
  static String bookingsUrl(int tableId) => '$baseUrl/tables/$tableId/bookings';
  
  /// Get booking by ID
  static String bookingUrl(int bookingId) => '$baseUrl/bookings/$bookingId';
  
  /// Create booking
  static String createBookingUrl(int tableId) => '$baseUrl/tables/$tableId/bookings';
  
  /// Update booking
  static String updateBookingUrl(int bookingId) => '$baseUrl/bookings/$bookingId';
  
  /// Cancel booking
  static String cancelBookingUrl(int bookingId) => '$baseUrl/bookings/$bookingId/cancel';
  
  /// Complete booking
  static String completeBookingUrl(int bookingId) => '$baseUrl/bookings/$bookingId/complete';
  
  // =============================================================================
  // ORDER ENDPOINTS
  // =============================================================================
  
  /// Get orders for a table
  static String ordersUrl(int tableId) => '$baseUrl/tables/$tableId/orders';
  
  /// Get order by ID
  static String orderUrl(int orderId) => '$baseUrl/orders/$orderId';
  
  /// Create order
  static String createOrderUrl(int tableId) => '$baseUrl/tables/$tableId/orders';
  
  /// Update order
  static String updateOrderUrl(int orderId) => '$baseUrl/orders/$orderId';
  
  /// Cancel order
  static String cancelOrderUrl(int orderId) => '$baseUrl/orders/$orderId/cancel';
  
  /// Complete order
  static String completeOrderUrl(int orderId) => '$baseUrl/orders/$orderId/complete';
  
  // =============================================================================
  // BILL ENDPOINTS
  // =============================================================================
  
  /// Get bills for a table
  static String billsUrl(int tableId) => '$baseUrl/tables/$tableId/bills';
  
  /// Get bill by ID
  static String billUrl(int billId) => '$baseUrl/bills/$billId';
  
  /// Create bill
  static String createBillUrl(int tableId) => '$baseUrl/tables/$tableId/bills';
  
  /// Update bill
  static String updateBillUrl(int billId) => '$baseUrl/bills/$billId';
  
  /// Pay bill
  static String payBillUrl(int billId) => '$baseUrl/bills/$billId/pay';
  
  // =============================================================================
  // USER ENDPOINTS
  // =============================================================================
  
  /// Get all users
  static String get usersUrl => '$baseUrl/users';
  
  /// Get user by ID
  static String userUrl(int userId) => '$baseUrl/users/$userId';
  
  /// Create user
  static String get createUserUrl => '$baseUrl/users';
  
  /// Update user
  static String updateUserUrl(int userId) => '$baseUrl/users/$userId';
  
  /// Delete user
  static String deleteUserUrl(int userId) => '$baseUrl/users/$userId';
  
  /// Get user profile
  static String get userProfileUrl => '$baseUrl/users/profile';
  
  /// Update user profile
  static String get updateUserProfileUrl => '$baseUrl/users/profile';
  
  // =============================================================================
  // MENU ENDPOINTS
  // =============================================================================
  
  /// Get menu items for a club
  static String menuItemsUrl(int clubId) => '$baseUrl/clubs/$clubId/menu-items';
  
  /// Get menu item by ID
  static String menuItemUrl(int itemId) => '$baseUrl/menu-items/$itemId';
  
  /// Create menu item
  static String createMenuItemUrl(int clubId) => '$baseUrl/clubs/$clubId/menu-items';
  
  /// Update menu item
  static String updateMenuItemUrl(int itemId) => '$baseUrl/menu-items/$itemId';
  
  /// Delete menu item
  static String deleteMenuItemUrl(int itemId) => '$baseUrl/menu-items/$itemId';
  
  // =============================================================================
  // SYSTEM ENDPOINTS
  // =============================================================================
  
  /// Health check endpoint
  static String get healthUrl => '$baseUrl/actuator/health';
  
  /// API documentation
  static String get apiDocsUrl => '$baseUrl/api-docs';
  
  /// Swagger UI
  static String get swaggerUrl => '$baseUrl/swagger-ui/index.html';
  
  // =============================================================================
  // WEBSOCKET ENDPOINTS
  // =============================================================================
  
  /// WebSocket base URL (remove /api/v1 for WebSocket)
  static String get websocketBaseUrl => baseUrl.replaceAll('/api/v1', '');
  
  /// Table status WebSocket
  static String tableStatusWebSocketUrl(int tableId) => '$websocketBaseUrl/ws/tables/$tableId/status';
  
  /// Order updates WebSocket
  static String orderUpdatesWebSocketUrl(int tableId) => '$websocketBaseUrl/ws/tables/$tableId/orders';
  
  // =============================================================================
  // UTILITY METHODS
  // =============================================================================
  
  /// Check if the API is using HTTPS
  static bool get isSecure => baseUrl.startsWith('https://');
  
  /// Get the host from the base URL
  static String get host {
    final uri = Uri.parse(baseUrl);
    return uri.host;
  }
  
  /// Get the port from the base URL
  static int get port {
    final uri = Uri.parse(baseUrl);
    return uri.port;
  }
  
  /// Get default headers for API requests
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  /// Get timeout configuration
  static Duration get connectTimeout => Duration(seconds: connectTimeoutSeconds);
  static Duration get receiveTimeout => Duration(seconds: receiveTimeoutSeconds);
}
