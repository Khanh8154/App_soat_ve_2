// lib/data_sources/remote_auth_source.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee.dart';
import 'auth_data_source.dart';

class RemoteAuthSource implements AuthDataSource {
  // !!! THAY THẾ BẰNG URL THẬT CỦA BẠN !!!
  final String _baseUrl = 'https://your-api-domain.com/api';

  @override
  Future<Employee?> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Nếu server trả về 200 OK
        final data = jsonDecode(response.body);
        // Giả sử server trả về JSON có dạng: {'id': 1, 'name': '...', 'username': '...'}
        return Employee(
          id: data['id'],
          name: data['name'],
          username: data['username'],
        );
      } else {
        // Nếu đăng nhập thất bại (sai pass, user không tồn tại)
        // Server nên trả về các mã lỗi như 401, 404
        print('Login failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Nếu có lỗi mạng hoặc không kết nối được server
      print('Error during remote login: $e');
      return null;
    }
  }
}