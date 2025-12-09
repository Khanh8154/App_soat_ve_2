// // lib/data_sources/remote_ticket_source.dart

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/ticket.dart';
// import 'ticket_data_source.dart';

// class RemoteTicketSource implements TicketDataSource {
//   // !!! THAY THẾ BẰNG URL THẬT CỦA BẠN !!!
//   final String _baseUrl = 'https://your-api-domain.com/api';

//   @override
//   Future<Ticket?> getTicketByQrCode(String qrCode) async {
//     // Giả sử API có endpoint để tìm vé theo mã QR
//     final url = Uri.parse('$_baseUrl/tickets?qrCode=$qrCode');

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         // API nên trả về một danh sách, ta lấy phần tử đầu tiên
//         if (data is List && data.isNotEmpty) {
//            // Giả sử server trả về JSON khớp với cấu trúc của Ticket
//            // Chúng ta cần một hàm factory mới trong model Ticket để xử lý JSON
//            return Ticket.fromJson(data.first);
//         }
//         return null;
//       } else if (response.statusCode == 404) {
//         // Server trả về 404 Not Found nếu không tìm thấy vé
//         return null;
//       } else {
//         throw Exception('Failed to load ticket');
//       }
//     } catch (e) {
//       print('Error getting ticket by QR code: $e');
//       return null;
//     }
//   }

//   @override
//   Future<int> updateTicket(Ticket ticket) async {
//     // API sẽ cập nhật vé dựa trên ID của nó
//     final url = Uri.parse('$_baseUrl/tickets/${ticket.id}');
    
//     try {
//       final response = await http.put(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         // Gửi toàn bộ đối tượng Ticket đã được cập nhật lên server
//         body: jsonEncode(ticket.toJson()),
//       );

//       if (response.statusCode == 200) {
//         return 1; // Thành công
//       } else {
//         return 0; // Thất bại
//       }
//     } catch (e) {
//       print('Error updating ticket: $e');
//       return 0;
//     }
//   }
// }