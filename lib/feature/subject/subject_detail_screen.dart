import 'package:dotto/repository/subject_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class SubjectDetailScreen extends HookConsumerWidget {
  const SubjectDetailScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subject = useFuture(useMemoized(() => ref.read(subjectRepositoryProvider).getSubject(id)));

    return Scaffold(appBar: AppBar(title: Text(subject.data?.name ?? '')));
  }
}
