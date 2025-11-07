// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TicketAdapter extends TypeAdapter<Ticket> {
  @override
  final int typeId = 1;

  @override
  Ticket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ticket(
      id: fields[0] as int,
      qrCode: fields[1] as String,
      customerName: fields[2] as String,
      phoneNumber: fields[3] as String,
      ticketType: fields[4] as String,
      isValid: fields[5] as bool,
      hasBeenScanned: fields[6] as bool,
      scannedAt: fields[7] as DateTime?,
      scannedByEmployeeId: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Ticket obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.qrCode)
      ..writeByte(2)
      ..write(obj.customerName)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.ticketType)
      ..writeByte(5)
      ..write(obj.isValid)
      ..writeByte(6)
      ..write(obj.hasBeenScanned)
      ..writeByte(7)
      ..write(obj.scannedAt)
      ..writeByte(8)
      ..write(obj.scannedByEmployeeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
