import 'package:core_domain/core_domain.dart';
import '../network/api_client.dart';
import '../exceptions/data_exceptions.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final ApiClient _apiClient;

  CompanyRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<Company>> getCompanies() async {
    try {
      final response = await _apiClient.get<List<dynamic>>('/api/v1/companies');

      if (response.data == null) {
        throw const DataException('Failed to fetch companies: No response data');
      }

      return response.data!
          .cast<Map<String, dynamic>>()
          .map((json) => Company.fromJson(json))
          .toList();
    } catch (e) {
      if (e is DataException) rethrow;
      throw DataException('Failed to fetch companies: ${e.toString()}', originalException: e);
    }
  }

  @override
  Future<Company> getCompanyById(String id) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>('/api/v1/companies/$id');

      if (response.data == null) {
        throw NotFoundException('Company not found: $id');
      }

      return Company.fromJson(response.data!);
    } catch (e) {
      if (e is DataException) rethrow;
      throw DataException('Failed to fetch company: ${e.toString()}', originalException: e);
    }
  }

  @override
  Future<Company> createCompany(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/v1/companies',
        data: data,
      );

      if (response.data == null) {
        throw const DataException('Failed to create company: No response data');
      }

      return Company.fromJson(response.data!);
    } catch (e) {
      if (e is DataException) rethrow;
      throw DataException('Failed to create company: ${e.toString()}', originalException: e);
    }
  }

  @override
  Future<Company> updateCompany(String id, Map<String, dynamic> updates) async {
    try {
      final response = await _apiClient.put<Map<String, dynamic>>(
        '/api/v1/companies/$id',
        data: updates,
      );

      if (response.data == null) {
        throw const DataException('Failed to update company: No response data');
      }

      return Company.fromJson(response.data!);
    } catch (e) {
      if (e is DataException) rethrow;
      throw DataException('Failed to update company: ${e.toString()}', originalException: e);
    }
  }

  @override
  Future<void> deleteCompany(String id) async {
    try {
      await _apiClient.delete('/api/v1/companies/$id');
    } catch (e) {
      if (e is DataException) rethrow;
      throw DataException('Failed to delete company: ${e.toString()}', originalException: e);
    }
  }
}
