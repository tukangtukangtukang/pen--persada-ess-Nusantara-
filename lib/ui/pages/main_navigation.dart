import 'package:flutter/material.dart';
import 'package:pen/ui/pages/home_page.dart';
import 'package:pen/ui/pages/production_page.dart';

import 'package:pen/ui/widget/bottom_navbar.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentBottomNavBar(
      screens: const [
        HomePage(),
        ProductionPage(),
        Center(child: Text('Produk Page')),
        Center(child: Text('Pembeli Page')),
      ],
      items: [
        PersistentBottomNavBarItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          title: 'Home',
          activeColor: Color.fromRGBO(56, 107, 246, 1),
          inactiveColor: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Icons.receipt_long_outlined,
          activeIcon: Icons.receipt_long,
          title: 'Produksi',
          activeColor: Color.fromRGBO(56, 107, 246, 1),
          inactiveColor: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Icons.inventory_2_outlined,
          activeIcon: Icons.inventory_2,
          title: 'Produk',
          activeColor: Color.fromRGBO(56, 107, 246, 1),
          inactiveColor: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          title: 'Pembeli',
          activeColor: Color.fromRGBO(56, 107, 246, 1),
          inactiveColor: Colors.grey,
        ),
      ],
    );
  }
}
