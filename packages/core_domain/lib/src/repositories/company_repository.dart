import '../models/company.dart';

abstract class CompanyRepository {
  Future<List<Company>> getCompanies();
  Future<Company> getCompanyById(String id);
  Future<Company> createCompany(Map<String, dynamic> data);
  Future<Company> updateCompany(String id, Map<String, dynamic> updates);
  Future<void> deleteCompany(String id);
}
