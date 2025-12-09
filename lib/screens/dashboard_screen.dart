// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:new_scanner_app/models/employee.dart';
import 'package:new_scanner_app/screens/scanned_tickets_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import 'scanner_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Tải dữ liệu thống kê ngay khi màn hình được tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employeeId = Provider.of<AuthProvider>(context, listen: false).employee?.id;
      if (employeeId != null) {
        Provider.of<DashboardProvider>(context, listen: false).fetchScannedTickets(employeeId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final employeeName = authProvider.employee?.name ?? 'Nhân viên';

    return Scaffold(
      appBar: AppBar(
        title: Text('Chào, $employeeName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authProvider.logout(),
          )
        ],
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, dashboard, child) {
          if (dashboard.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Thẻ thống kê
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Thống kê quét vé',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildStatRow('Tổng vé đã quét:', '${dashboard.totalScanned}'),
                        const SizedBox(height: 8),
                        _buildStatRow('Quét trong hôm nay:', '${dashboard.totalScannedToday}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Nút xem chi tiết
                ElevatedButton.icon(
                  icon: const Icon(Icons.list_alt),
                  label: const Text('Xem chi tiết vé đã quét'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ScannedTicketsScreen(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const Spacer(),

                // Nút bắt đầu quét
                ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('BẮT ĐẦU QUÉT VÉ'),
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ScannerScreen(),
                    ));
                    if (mounted){
                      final employeeId = Provider.of<AuthProvider>(context, listen: false).employee?.id;
                      if (employeeId != null){
                        Provider.of<DashboardProvider>(context, listen: false).fetchScannedTickets(employeeId);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}