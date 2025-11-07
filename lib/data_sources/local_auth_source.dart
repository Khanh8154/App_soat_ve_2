// lib/data_sources/local_auth_source.dart

import '../models/employee.dart';
import 'auth_data_source.dart';
import 'database_service.dart';

class LocalAuthSource implements AuthDataSource {
  // Lấy ra employee box từ database service
  final _employeeBox = DatabaseService.instance.employeeBox;

  // Mật khẩu giả lập để kiểm tra
  final _passwords = {
    'nhanviena': '123',
    'nhanvienb': '123',
  };

  @override
  Future<Employee?> login(String username, String password) async {
    // 1. Kiểm tra mật khẩu có khớp không
    if (_passwords[username] == password) {
      // 2. Nếu khớp, lấy thông tin Employee từ box bằng key (chính là username)
      final employee = _employeeBox.get(username);
      return employee;
    }
    
    // 3. Nếu mật khẩu sai hoặc không tìm thấy user, trả về null
    return null;
  }
}