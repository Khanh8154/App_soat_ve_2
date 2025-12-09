// lib/data_sources/local_ticket_source.dart

import '../models/ticket.dart';
import 'database_service.dart';
import 'ticket_data_source.dart';

class LocalTicketSource implements TicketDataSource {
  final _ticketBox = DatabaseService.instance.ticketBox;

  @override
  Future<Ticket?> getTicketByQrCode(String qrCode) async {
    // Đơn giản chỉ cần lấy vé từ box bằng key (chính là qrCode)
    final ticket = _ticketBox.get(qrCode);
    return ticket;
  }

  @override
  Future<int> updateTicket(Ticket ticket) async {
    try {
      // Ghi đè vé cũ bằng vé mới tại cùng một key
      await _ticketBox.put(ticket.qrCode, ticket);
      return 1; // Trả về 1 để báo hiệu thành công (tương tự như sqflite)
    } catch (e) {
      return 0; // Trả về 0 nếu có lỗi
    }
  }
  Future<List<Ticket>> getAllTickets() async {
    return _ticketBox.values.toList();
  }
}