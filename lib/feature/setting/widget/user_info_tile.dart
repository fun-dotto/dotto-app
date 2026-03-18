import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:dotto/asset.dart';

final class UserInfoTile extends StatelessWidget {
  const UserInfoTile({super.key, required this.user, this.onTap});

  /// 表示するユーザー（Firebase Auth の User）
  final User user;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<SemanticColor>()!;
    final photoURL = user.photoURL; // String? のまま
    final name = (user.displayName?.trim().isNotEmpty ?? false) ? user.displayName!.trim() : '名前が設定されていません';
    final email = user.email ?? '';

    final avatar = ClipOval(
      child: SizedBox(
        width: 44,

        height: 44,
        //photoURLがnullまたは空文字列でない場合はImage.networkを使用し、それ以外の場合はImage.assetを使用する
        child: (photoURL != null && photoURL.trim().isNotEmpty)
            ? Image.network(
                photoURL,

                fit: BoxFit.cover,

                errorBuilder: (_, __, ___) => Image.asset(Asset.noImage, fit: BoxFit.cover),
              )
            : Image.asset(Asset.noImage, fit: BoxFit.cover),
      ),
    );
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: semantic.backgroundSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: semantic.borderPrimary),
      ),
      child: Row(
        children: [
          avatar,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(name), const SizedBox(height: 2), Text(email)],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: semantic.labelSecondary),
        ],
      ),
    );
    return const SizedBox(); // 仮
  }
}
