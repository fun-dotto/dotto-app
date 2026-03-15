import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:dotto/asset.dart';

final class UserInfoTile extends StatelessWidget {
  const UserInfoTile({super.key, required this.user});

  /// 表示するユーザー（Firebase Auth の User）
  final User user;

  @override
  Widget build(BuildContext context) {
    return const SizedBox(); // 仮
  }
}
