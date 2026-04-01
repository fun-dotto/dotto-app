import 'package:flutter/material.dart';

enum TabItem {
  course(key: 'course', title: '講義', icon: Icons.description_outlined, activeIcon: Icons.description),
  funch(key: 'funch', title: '学食', icon: Icons.restaurant_outlined, activeIcon: Icons.restaurant),
  map(key: 'map', title: 'マップ', icon: Icons.map_outlined, activeIcon: Icons.map),
  bus(key: 'bus', title: 'バス', icon: Icons.directions_bus_outlined, activeIcon: Icons.directions_bus),
  setting(key: 'setting', title: '設定', icon: Icons.settings_outlined, activeIcon: Icons.settings),
  // v1 only
  home(key: 'home', title: 'ホーム', icon: Icons.home_outlined, activeIcon: Icons.home),
  subject(key: 'subject', title: '科目検索', icon: Icons.search_outlined, activeIcon: Icons.search);

  const TabItem({required this.key, required this.title, required this.icon, required this.activeIcon});

  final String key;
  final String title;
  final IconData icon;
  final IconData activeIcon;

  static final List<TabItem> v2 = [.course, .funch, .map, .bus, .setting];
  static final List<TabItem> v1 = [.home, .map, .subject, .setting];
}
