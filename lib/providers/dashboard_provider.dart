// lib/providers/dashboard_provider.dart

import 'package:flutter/material.dart';
import '../models/ticket.dart';
import '../repositories/ticket_repository.dart';

class DashboardProvider with ChangeNotifier {
  final TicketRepository _ticketRepository = TicketRepository();

  List<Ticket> _scannedTickets = [];
  List<Ticket> get scannedTickets => _scannedTickets;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int get totalScanned => _scannedTickets.length;

  int get totalScannedToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _scannedTickets.where((ticket) {
      final scannedDate = DateTime(ticket.scannedAt!.year, ticket.scannedAt!.month, ticket.scannedAt!.day);
      return scannedDate.isAtSameMomentAs(today);
    }).length;
  }

  // Hàm để tải dữ liệu thống kê
  Future<void> fetchScannedTickets(int employeeId) async {
    _isLoading = true;
    notifyListeners();

    _scannedTickets = await _ticketRepository.getScannedTicketsByEmployee(employeeId);
    
    _isLoading = false;
    notifyListeners();
  }
}