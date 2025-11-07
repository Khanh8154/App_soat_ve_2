// lib/data_sources/auth_data_source.dart

import '../models/employee.dart';

abstract class AuthDataSource {
  // Trả về đối tượng Employee nếu đăng nhập thành công
  // Trả về null nếu đăng nhập thất bại
  Future<Employee?> login(String username, String password);
}