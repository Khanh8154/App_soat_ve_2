// lib/repositories/ticket_repository.dart

import '../data_sources/local_ticket_source.dart';
import '../data_sources/ticket_data_source.dart';
import '../models/ticket.dart';

// Chúng ta sẽ dùng enum để định nghĩa các trạng thái trả về cho UI
// Điều này giúp code ở tầng UI sạch sẽ và dễ hiểu hơn.
enum TicketValidationResult {
  valid,
  invalidQr,
  alreadyScanned,
  error,
}

class TicketRepository {
  final TicketDataSource _localDataSource = LocalTicketSource();
  // final TicketDataSource _remoteDataSource = RemoteTicketSource();

  final bool _useLocal = true;

  // Hàm này sẽ trả về cả trạng thái và thông tin vé (nếu có)
  Future<(TicketValidationResult, Ticket?)> validateTicket(String qrCode, int employeeId) async {
    try {
      final TicketDataSource dataSource = _useLocal ? _localDataSource : throw UnimplementedError();

      // 1. Tìm vé trong database
      final ticket = await dataSource.getTicketByQrCode(qrCode);

      // 2. Nếu không tìm thấy vé -> Mã QR không hợp lệ
      if (ticket == null) {
        return (TicketValidationResult.invalidQr, null);
      }

      // 3. Nếu vé đã được quét trước đó -> Báo đã quét
      if (ticket.hasBeenScanned) {
        return (TicketValidationResult.alreadyScanned, ticket);
      }

      // 4. Nếu vé hợp lệ và chưa quét -> Cập nhật thông tin vé
      final updatedTicket = Ticket(
        id: ticket.id,
        qrCode: ticket.qrCode,
        customerName: ticket.customerName,
        phoneNumber: ticket.phoneNumber,
        ticketType: ticket.ticketType,
        isValid: ticket.isValid,
        hasBeenScanned: true, // Đánh dấu đã quét
        scannedAt: DateTime.now(), // Ghi lại thời gian
        scannedByEmployeeId: employeeId, // Ghi lại nhân viên quét
      );

      await dataSource.updateTicket(updatedTicket);

      // 5. Trả về trạng thái hợp lệ và vé đã được cập nhật
      return (TicketValidationResult.valid, updatedTicket);

    } catch (e) {
      // Nếu có bất kỳ lỗi nào khác xảy ra
      print('Error validating ticket: $e');
      return (TicketValidationResult.error, null);
    }
  }
}