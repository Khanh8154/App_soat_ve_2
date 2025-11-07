// lib/data_sources/database_service.dart

import 'package:hive_flutter/hive_flutter.dart';
import '../models/employee.dart';
import '../models/ticket.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService instance = DatabaseService._init();
  DatabaseService._init();

  // Các box sẽ được mở và truy cập từ bất cứ đâu
  late Box<Employee> employeeBox;
  late Box<Ticket> ticketBox;

  Future<void> init() async {
    // 1. Khởi tạo Hive và chỉ định thư mục lưu trữ
    await Hive.initFlutter();

    // 2. Đăng ký các Adapters đã được tạo tự động
    //    Nếu bạn thêm model mới, hãy đăng ký adapter của nó ở đây
    Hive.registerAdapter(EmployeeAdapter());
    Hive.registerAdapter(TicketAdapter());

    // 3. Mở các boxes
    employeeBox = await Hive.openBox<Employee>('employees');
    ticketBox = await Hive.openBox<Ticket>('tickets');
    
    // 4. Thêm dữ liệu giả nếu các box còn trống (chỉ chạy lần đầu)
    await _seedDatabase();
  }

  Future<void> _seedDatabase() async {
    // Thêm nhân viên giả nếu box chưa có
    if (employeeBox.isEmpty) {
      print("--- Seeding Employees ---");
      final employeeA = Employee(id: 1, name: 'Nguyễn Văn A', username: 'nhanviena');
      final employeeB = Employee(id: 2, name: 'Trần Thị B', username: 'nhanvienb');
      // Key là username để dễ dàng truy vấn
      await employeeBox.put(employeeA.username, employeeA);
      await employeeBox.put(employeeB.username, employeeB);
    }

    // Thêm vé giả nếu box chưa có
    if (ticketBox.isEmpty) {
      print("--- Seeding Tickets ---");
      final ticket1 = Ticket(id: 1, qrCode: 'EVENT-ABC-111', customerName: 'Lê Quang Huy', phoneNumber: '0905111222', ticketType: 'VIP');
      final ticket2 = Ticket(id: 2, qrCode: 'EVENT-ABC-222', customerName: 'Phạm Thị Duyên', phoneNumber: '0913333444', ticketType: 'Thường');
      final ticket3 = Ticket(
        id: 3,
        qrCode: 'EVENT-ABC-333',
        customerName: 'Đỗ Bích Trâm',
        phoneNumber: '0989555666',
        ticketType: 'VIP',
        hasBeenScanned: true, // Vé này đã được quét
        scannedAt: DateTime.now(),
        scannedByEmployeeId: 1, // Quét bởi nhân viên A
      );
      // Key là qrCode để dễ dàng truy vấn
      await ticketBox.put(ticket1.qrCode, ticket1);
      await ticketBox.put(ticket2.qrCode, ticket2);
      await ticketBox.put(ticket3.qrCode, ticket3);
    }
  }
}