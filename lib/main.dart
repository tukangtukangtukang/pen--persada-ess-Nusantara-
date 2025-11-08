// lib/main.dart - Updated Version
import 'package:flutter/material.dart';
import 'package:pen/ui/pages/home_page.dart';
import 'package:pen/ui/pages/splash_screen.dart';
import 'package:pen/ui/pages/production_page.dart';
import 'package:pen/ui/pages/sales_page.dart';

// Import page baru
import 'package:pen/ui/pages/customer_page.dart'; // <-- Sudah ada
import 'package:pen/ui/pages/supplier_page.dart'; // <-- Buat file ini
import 'package:pen/ui/pages/transaksi_page.dart'; // <-- Buat file ini
import 'package:pen/ui/pages/setoran_page.dart';   // <-- Buat file ini

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persada ESS Nusantara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomePage(),
        '/production': (context) => const ProductionPage(),
        '/sales': (context) => const SalesPage(),
        
        // Ganti PlaceholderPage dengan page yang sesuai
        '/setoran': (context) => const SetoranPage(),
        '/customers': (context) => const CustomerPage(),
        '/suppliers': (context) => const SupplierPage(),
        '/transactions': (context) => const TransaksiPage(),
      },
    );
  }
}

// Placeholder page (bisa dihapus jika semua rute sudah diimplementasikan)
class PlaceholderPage extends StatelessWidget {
  final String title;
  
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Halaman $title',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dalam pengembangan',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}