// lib/ui/pages/home_page.dart - Updated Version
import 'package:flutter/material.dart';
import 'package:pen/ui/theme/theme.dart';
import 'package:pen/ui/widget/statistical_card.dart';
import 'package:pen/ui/widget/graphic.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    String nama = "Fahmi";
    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: lightGray,
        leading: IconButton(
          onPressed: () {},
          icon: Image.asset('assets/man.png', width: 40, height: 40),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi, $nama 👋", style: headingStyle.copyWith(fontSize: 16)),
            Text(
              "Welcome back PEN",
              style: subheadingStyle.copyWith(fontSize: 12),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: white,
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_outlined, color: black),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const StatisticalCard(
                        title: 'Total order',
                        icon: Icon(Icons.shopping_cart, color: Colors.blue),
                        numericData: '234',
                        cardColor: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      const StatisticalCard(
                        title: 'Diproduksi',
                        icon: Icon(Icons.settings, color: amber),
                        numericData: '23',
                        cardColor: white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const StatisticalCard(
                        title: 'Dikirim',
                        icon: Icon(Icons.local_shipping, color: green),
                        numericData: '234',
                        cardColor: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      const StatisticalCard(
                        title: 'Pesanan Selesai',
                        icon: Icon(Icons.check_circle, color: purple),
                        numericData: '1000',
                        cardColor: white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const GraphicalCard(),
                  const SizedBox(height: 24),
                  
                  // Quick Action Buttons
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Menu Utama',
                          style: headingStyle.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMenuButton(
                                context,
                                'Produksi',
                                Icons.factory,
                                amber,
                                '/production',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMenuButton(
                                context,
                                'Penjualan',
                                Icons.point_of_sale,
                                green,
                                '/sales',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMenuButton(
                                context,
                                'Setoran',
                                Icons.account_balance_wallet,
                                purple,
                                '/setoran',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMenuButton(
                                context,
                                'Pelanggan',
                                Icons.people,
                                Colors.blue,
                                '/customers',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMenuButton(
                                context,
                                'Supplier',
                                Icons.local_shipping,
                                Colors.orange,
                                '/suppliers',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMenuButton(
                                context,
                                'Transaksi',
                                Icons.receipt_long,
                                Colors.red,
                                '/transactions',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String route,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}