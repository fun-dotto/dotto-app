import 'package:dotto/api/api_client.dart';
import 'package:dotto/feature/subject/subject_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class SubjectDetailScreen extends HookConsumerWidget {
  const SubjectDetailScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiClient = ref.read(apiClientProvider);
    final subjectRepository = SubjectRepositoryImpl(apiClient);
    final subject = useFuture(useMemoized(() => subjectRepository.getSubject(id)));

    return Scaffold(appBar: AppBar(title: Text(subject.data?.name ?? '')));
  }
}
