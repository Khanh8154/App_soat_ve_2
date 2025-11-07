// lib/repositories/auth_repository.dart

import '../data_sources/auth_data_source.dart';
import '../data_sources/local_auth_source.dart';
import '../models/employee.dart';

class AuthRepository {
  // Trong tương lai, chúng ta có thể có thêm remoteDataSource ở đây
  // final AuthDataSource _remoteDataSource;
  final AuthDataSource _localDataSource = LocalAuthSource();

  // Biến này cho phép chúng ta chuyển đổi giữa chế độ local và online
  final bool _useLocal = true;

  Future<Employee?> login(String username, String password) {
    if (_useLocal) {
      return _localDataSource.login(username, password);
    } else {
      // Sau này sẽ gọi API ở đây
      // return _remoteDataSource.login(username, password);
      throw UnimplementedError('Remote login is not implemented yet.');
    }
  }
}