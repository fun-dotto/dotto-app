import 'package:dotto/feature/github_contributor/github_contributor_service.dart';
import 'package:dotto/feature/github_contributor/github_contributor_viewstate.dart';
import 'package:dotto/repository/github_contributor_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'github_contributor_viewmodel.g.dart';

final gitHubContributorRepositoryProvider =
    Provider<GitHubContributorRepository>(
      (_) => GitHubContributorRepositoryImpl(),
    );

@riverpod
final class GitHubContributorViewModel extends _$GitHubContributorViewModel {
  late final GitHubContributorService _service;

  @override
  Future<GitHubContributorViewState> build() async {
    _service = GitHubContributorService(
      ref.read(gitHubContributorRepositoryProvider),
    );
    final contributors = await _service.getContributors();
    return GitHubContributorViewState(contributors: contributors);
  }

  Future<void> onRefresh() async {
    state = await AsyncValue.guard(() async {
      final contributors = await _service.getContributors();
      return GitHubContributorViewState(contributors: contributors);
    });
  }
}
