import 'package:dotto/domain/dotto_user.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class UserInfoTile extends StatelessWidget {
  const UserInfoTile({super.key, required this.user, this.onTap});

  /// 表示するユーザー（DottoUser）
  final DottoUser user;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final photoUrl = user.avatarUrl;
    final name = (user.name.trim().isNotEmpty) ? user.name.trim() : 'ログイン';
    final email = user.email.trim().isNotEmpty ? '${user.email.trim()}でログイン中' : 'Google アカウント (@fun.ac.jp) でログイン';
    final avatar = Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: SemanticColor.light.borderPrimary),
      ),
      child: ClipOval(
        child: SizedBox(
          width: 44,
          height: 44,
          // photoUrl が空文字列でない場合は Image.network を使用し、それ以外の場合は Image.asset を使用する
          child: (photoUrl.trim().isNotEmpty)
              ? Image.network(photoUrl, fit: BoxFit.cover, errorBuilder: (_, _, _) => Icon(Icons.person))
              : const Icon(Icons.person),
        ),
      ),
    );
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        spacing: 12,
        children: [
          avatar,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(name), const SizedBox(height: 2), Text(email)],
            ),
          ),
          Icon(Icons.chevron_right, color: SemanticColor.light.labelSecondary),
        ],
      ),
    );
    return Material(
      color: SemanticColor.light.backgroundSecondary,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12), child: content),
    );
  }
}
