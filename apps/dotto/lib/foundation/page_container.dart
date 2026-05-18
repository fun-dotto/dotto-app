import 'package:dotto/foundation/page_async_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class PageContainer extends HookConsumerWidget {
  const PageContainer({
    required this.pageAsyncStates,
    required this.child,
    super.key,
  });

  final PageAsyncStates pageAsyncStates;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return child;
  }
}
