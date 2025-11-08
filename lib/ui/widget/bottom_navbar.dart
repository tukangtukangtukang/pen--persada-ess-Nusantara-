import 'package:flutter/material.dart';

class PersistentBottomNavBar extends StatefulWidget {
  final List<Widget> screens;
  final List<PersistentBottomNavBarItem> items;
  final Color? backgroundColor;
  final double? elevation;
  final EdgeInsets? padding;

  const PersistentBottomNavBar({
    super.key,
    required this.screens,
    required this.items,
    this.backgroundColor,
    this.elevation = 8.0,
    this.padding,
  }) : assert(screens.length == items.length, 
              'Screens and items must have the same length');

  @override
  State<PersistentBottomNavBar> createState() => _PersistentBottomNavBarState();
}

class _PersistentBottomNavBarState extends State<PersistentBottomNavBar> {
  int _selectedIndex = 0;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.screens.length; i++) {
      _navigatorKeys.add(GlobalKey<NavigatorState>());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: widget.screens.asMap().entries.map((entry) {
          return Navigator(
            key: _navigatorKeys[entry.key],
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => entry.value,
              );
            },
          );
        }).toList(),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: widget.elevation ?? 8.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widget.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == _selectedIndex;

              return Expanded(
                child: InkWell(
                  onTap: () => _onItemTapped(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          color: isSelected 
                              ? item.activeColor 
                              : item.inactiveColor,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected 
                                ? FontWeight.w600 
                                : FontWeight.normal,
                            color: isSelected 
                                ? item.activeColor 
                                : item.inactiveColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      // Pop to first route if tapping the same tab
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}

class PersistentBottomNavBarItem {
  final IconData icon;
  final IconData activeIcon;
  final String title;
  final Color activeColor;
  final Color inactiveColor;

  PersistentBottomNavBarItem({
    required this.icon,
    IconData? activeIcon,
    required this.title,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
  }) : activeIcon = activeIcon ?? icon;
}