import 'package:dotto/asset.dart';
import 'package:dotto/domain/dotto_user.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class UserInfoTile extends StatelessWidget {
  const UserInfoTile({super.key, required this.user, this.onTap});

  /// 表示するユーザー（Firebase Auth の User）
  final DottoUser user;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<SemanticColor>()!;
    final photoURL = user.avatarUrl; // String? のまま
    final name = (user.name.trim().isNotEmpty) ? user.name.trim() : 'ログイン';
    final email = user.email.trim().isNotEmpty ? '${user.email.trim()}でログイン中' : 'Google アカウント (@fun.ac.jp) でログイン';

    final avatar = ClipOval(
      child: SizedBox(
        width: 44,

        height: 44,
        //photoURLがnullまたは空文字列でない場合はImage.networkを使用し、それ以外の場合はImage.assetを使用する
        child: (photoURL.trim().isNotEmpty)
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
    //もし処理がなければcontentを返してただのカードを表示して終了する
    if (onTap == null) return content;
    //処理があればtapできて波紋波紋エフェクトが出る
    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(14), child: content),
    );
  }
}
