// lib/models/ticket.dart

import 'package:hive/hive.dart';

part 'ticket.g.dart';

@HiveType(typeId: 1)
class Ticket {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String qrCode;

  @HiveField(2)
  final String customerName;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final String ticketType;

  @HiveField(5)
  final bool isValid;

  @HiveField(6)
  final bool hasBeenScanned;

  @HiveField(7)
  final DateTime? scannedAt;

  @HiveField(8)
  final int? scannedByEmployeeId;

  Ticket({
    required this.id,
    required this.qrCode,
    required this.customerName,
    required this.phoneNumber,
    required this.ticketType,
    this.isValid = true,
    this.hasBeenScanned = false,
    this.scannedAt,
    this.scannedByEmployeeId,
  });
}