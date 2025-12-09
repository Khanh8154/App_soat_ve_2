// lib/screens/scanned_tickets_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';

class ScannedTicketsScreen extends StatelessWidget {
  const ScannedTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboard = Provider.of<DashboardProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vé đã quét'),
      ),
      body: dashboard.scannedTickets.isEmpty
          ? const Center(
              child: Text('Chưa có vé nào được quét.'),
            )
          : ListView.builder(
              itemCount: dashboard.scannedTickets.length,
              itemBuilder: (context, index) {
                final ticket = dashboard.scannedTickets[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(ticket.customerName),
                    subtitle: Text('Loại vé: ${ticket.ticketType}\nQR: ${ticket.qrCode}'),
                    trailing: Text(
                      DateFormat('HH:mm').format(ticket.scannedAt!),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }
}