import 'package:dotto/domain/dotto_user.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

final class UserInfoTile extends StatelessWidget {
  const UserInfoTile({super.key, required this.user, this.onTap, this.isLoading = false});

  /// 表示するユーザー（DottoUser）
  final DottoUser user;
  final void Function()? onTap;
  final bool isLoading;

  Widget _buildSkeleton({
    required double width,
    required double height,
    BorderRadius? borderRadius,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return Shimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: shape == BoxShape.circle ? null : (borderRadius ?? BorderRadius.circular(8)),
          shape: shape,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = user.avatarUrl;
    final name = (user.name.trim().isNotEmpty) ? user.name.trim() : 'ログイン';
    final email = user.email.trim().isNotEmpty ? '${user.email.trim()}でログイン中' : 'Google アカウント (@fun.ac.jp) でログイン';
    final avatar = isLoading
        ? _buildSkeleton(width: 44, height: 44, shape: BoxShape.circle)
        : Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: SemanticColor.light.borderPrimary),
            ),
            child: ClipOval(
              child: SizedBox(
                width: 48,
                height: 48,
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
              children: isLoading
                  ? [
                      _buildSkeleton(width: 120, height: 16),
                      const SizedBox(height: 8),
                      _buildSkeleton(width: 220, height: 14),
                    ]
                  : [
                      Text(name, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        email,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: SemanticColor.light.labelSecondary),
                      ),
                    ],
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
      child: InkWell(onTap: isLoading ? null : onTap, borderRadius: BorderRadius.circular(12), child: content),
    );
  }
}
