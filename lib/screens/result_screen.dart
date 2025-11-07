// lib/screens/result_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thêm thư viện để format ngày giờ
import '../models/ticket.dart';
import '../repositories/ticket_repository.dart';

class ResultScreen extends StatelessWidget {
  final TicketValidationResult result;
  final Ticket? ticket;

  const ResultScreen({
    super.key,
    required this.result,
    this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    // Tùy chỉnh giao diện dựa trên kết quả
    IconData icon;
    Color color;
    String title;
    List<Widget> details = [];

    switch (result) {
      case TicketValidationResult.valid:
        icon = Icons.check_circle;
        color = Colors.green;
        title = 'VÉ HỢP LỆ';
        if (ticket != null) {
          details = _buildTicketDetails(ticket!);
        }
        break;
      case TicketValidationResult.alreadyScanned:
        icon = Icons.warning;
        color = Colors.orange;
        title = 'VÉ ĐÃ ĐƯỢC QUÉT';
        if (ticket != null) {
          details = _buildTicketDetails(ticket!);
        }
        break;
      case TicketValidationResult.invalidQr:
        icon = Icons.error;
        color = Colors.red;
        title = 'MÃ QR KHÔNG TỒN TẠI';
        break;
      case TicketValidationResult.error:
        icon = Icons.cancel;
        color = Colors.red;
        title = 'ĐÃ XẢY RA LỖI';
        details = [const Text('Vui lòng thử lại sau.', textAlign: TextAlign.center)];
        break;
    }

    return Scaffold(
      backgroundColor: color,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(icon, color: Colors.white, size: 120),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            // Hiển thị chi tiết vé trong một thẻ Card
            if (details.isNotEmpty)
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: details,
                  ),
                ),
              ),
            
            const Spacer(),

            // Nút để quay lại màn hình quét
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('QUÉT VÉ TIẾP THEO'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm helper để xây dựng danh sách chi tiết vé
  List<Widget> _buildTicketDetails(Ticket t) {
    return [
      _DetailRow(title: 'Khách hàng:', value: t.customerName),
      _DetailRow(title: 'Số điện thoại:', value: t.phoneNumber),
      _DetailRow(title: 'Loại vé:', value: t.ticketType),
      if (t.scannedAt != null)
        _DetailRow(
          title: 'Quét lúc:',
          // Format ngày giờ cho dễ đọc
          value: DateFormat('HH:mm:ss - dd/MM/yyyy').format(t.scannedAt!),
        ),
    ];
  }
}

// Widget nhỏ để hiển thị một hàng chi tiết cho gọn
class _DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const _DetailRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}