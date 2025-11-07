// lib/screens/scanner_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../repositories/ticket_repository.dart';
import 'result_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController();
  final TicketRepository _ticketRepository = TicketRepository();
  bool _isProcessing = false; // Cờ để tránh quét nhiều lần liên tiếp

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return; // Nếu đang xử lý thì bỏ qua

    setState(() {
      _isProcessing = true;
    });

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? qrCode = barcodes.first.rawValue;

      if (qrCode != null) {
        // Lấy thông tin nhân viên từ provider
        final employee = Provider.of<AuthProvider>(context, listen: false).employee;
        if (employee == null) {
          // Trường hợp hiếm gặp, nhưng nên xử lý
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lỗi: Không tìm thấy thông tin nhân viên.')),
          );
          setState(() { _isProcessing = false; });
          return;
        }

        // Gọi repository để xác thực vé
        final (result, ticket) = await _ticketRepository.validateTicket(qrCode, employee.id);

        // Dừng camera và điều hướng đến màn hình kết quả
        _scannerController.stop();
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ResultScreen(result: result, ticket: ticket),
          ),
        );
        
        // Sau khi quay lại từ màn hình kết quả, khởi động lại camera
        if (mounted) {
          _scannerController.start();
          setState(() {
            _isProcessing = false;
          });
        }
      } else {
         setState(() { _isProcessing = false; });
      }
    } else {
       setState(() { _isProcessing = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lấy tên nhân viên để hiển thị chào mừng
    final employeeName = Provider.of<AuthProvider>(context, listen: false).employee?.name ?? 'Nhân viên';
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Xin chào, $employeeName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Gọi hàm đăng xuất từ provider
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
          ),
          // Lớp phủ (overlay) để hướng dẫn người dùng
          Center(
            child: Container( 
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // Hiển thị vòng xoay loading khi đang xử lý
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}