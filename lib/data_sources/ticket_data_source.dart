// lib/data_sources/ticket_data_source.dart

import '../models/ticket.dart';

abstract class TicketDataSource {
  // Tìm một vé dựa trên mã QR
  Future<Ticket?> getTicketByQrCode(String qrCode);

  // Cập nhật trạng thái của một vé (đã quét, bởi ai, lúc nào)
  Future<int> updateTicket(Ticket ticket);
}