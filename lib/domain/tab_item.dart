import 'package:flutter/material.dart';

enum TabItem {
  course(key: 'course', label: '講義', icon: Icons.description_outlined, selectedIcon: Icons.description),
  funch(key: 'funch', label: '学食', icon: Icons.restaurant_outlined, selectedIcon: Icons.restaurant),
  map(key: 'map', label: 'マップ', icon: Icons.map_outlined, selectedIcon: Icons.map),
  bus(key: 'bus', label: 'バス', icon: Icons.directions_bus_outlined, selectedIcon: Icons.directions_bus),
  setting(key: 'setting', label: '設定', icon: Icons.settings_outlined, selectedIcon: Icons.settings),
  // v1 only
  home(key: 'home', label: 'ホーム', icon: Icons.home_outlined, selectedIcon: Icons.home),
  subject(key: 'subject', label: '科目検索', icon: Icons.search_outlined, selectedIcon: Icons.search);

  const TabItem({required this.key, required this.label, required this.icon, required this.selectedIcon});

  final String key;
  final IconData selectedIcon;
  final IconData icon;
  final String label;

  static final List<TabItem> v2 = [.course, .funch, .map, .bus, .setting];
  static final List<TabItem> v1 = [.home, .map, .subject, .setting];
}
