// lib/models/employee.dart

import 'package:hive/hive.dart';

part 'employee.g.dart';

@HiveType(typeId: 0)
class Employee {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String username;

  Employee({
    required this.id,
    required this.name,
    required this.username,
  });
}