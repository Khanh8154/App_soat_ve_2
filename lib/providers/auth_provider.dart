// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  // Biến `_employee` sẽ lưu thông tin nhân viên.
  // `null` có nghĩa là chưa đăng nhập.
  Employee? _employee;
  Employee? get employee => _employee;

  // Cờ để hiển thị vòng xoay loading trên UI
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Biến lưu thông báo lỗi để hiển thị
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  // Kiểm tra xem đã đăng nhập hay chưa
  bool get isAuthenticated => _employee != null;

  // Hàm đăng nhập chính
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Báo cho UI cập nhật (hiện loading)

    try {
      _employee = await _authRepository.login(username, password);

      if (_employee != null) {
        _isLoading = false;
        notifyListeners(); // Cập nhật UI (ẩn loading)
        return true; // Đăng nhập thành công
      } else {
        _errorMessage = 'Tên đăng nhập hoặc mật khẩu không đúng.';
        _isLoading = false;
        notifyListeners(); // Cập nhật UI (hiển thị lỗi)
        return false; // Đăng nhập thất bại
      }
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi. Vui lòng thử lại.';
      _isLoading = false;
      notifyListeners(); // Cập nhật UI (hiển thị lỗi)
      return false;
    }
  }

  // Hàm đăng xuất
  void logout() {
    _employee = null;
    notifyListeners(); // Báo cho UI biết là đã đăng xuất
  }
}