// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // MỚI
import 'data_sources/database_service.dart';
import 'providers/auth_provider.dart'; // MỚI
import 'screens/login_screen.dart'; // MỚI
import 'screens/scanner_screen.dart'; // MỚI
import 'providers/dashboard_provider.dart'; // THÊM DÒNG NÀY
import 'screens/dashboard_screen.dart'; // THÊM DÒNG NÀY

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.init();
  
  runApp(
    // Bọc ứng dụng của chúng ta bằng một MultiProvider
    MultiProvider(
      providers: [
        // Cung cấp AuthProvider cho toàn bộ cây widget
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticket Scanner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Sử dụng Consumer để lắng nghe trạng thái đăng nhập
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isAuthenticated) {
            // Nếu đã đăng nhập, hiển thị màn hình quét
            return const DashboardScreen();
          } else {
            // Nếu chưa, hiển thị màn hình đăng nhập
            return const LoginScreen();
          }
        },
      ),
    );
  }
}