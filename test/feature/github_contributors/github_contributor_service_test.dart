import 'package:dotto/domain/github_profile.dart';
import 'package:dotto/feature/github_contributor/github_contributor_service.dart';
import 'package:dotto/repository/github_contributor_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'github_contributor_service_test.mocks.dart';

@GenerateMocks([GitHubContributorRepository])
void main() {
  final githubContributorRepository = MockGitHubContributorRepository();

  final testGitHubProfiles = [
    GitHubProfile(
      id: '1',
      login: 'GitHubUser1',
      avatarUrl: 'https://avatars.githubusercontent.com/u/1?v=4',
      htmlUrl: 'https://github.com/GitHubUser1',
      contributions: 50,
    ),
    GitHubProfile(
      id: '2',
      login: 'GitHubUser2',
      avatarUrl: 'https://avatars.githubusercontent.com/u/2?v=4',
      htmlUrl: 'https://github.com/GitHubUser2',
      contributions: 100,
    ),
  ];

  setUp(() {
    reset(githubContributorRepository);
  });

  group('GitHubContributorService 正常系', () {
    test('getContributors がGitHubプロフィール一覧を正しく取得する', () async {
      when(githubContributorRepository.getContributors()).thenAnswer((_) async => testGitHubProfiles);

      final service = GitHubContributorService(githubContributorRepository);

      final result = await service.getContributors();

      // Service 経由で取得した結果が contributions の降順 (100 → 50) になっていることを確認
      expect(result[0].contributions, 100);
      expect(result[1].contributions, 50);
      // contributions に応じて並び順が変わっていることを確認
      expect(result[0].id, '2');
      expect(result[0].login, 'GitHubUser2');
      expect(result[1].id, '1');
      expect(result[1].login, 'GitHubUser1');

      verify(githubContributorRepository.getContributors()).called(1);
    });

    test('getContributors が空のリストを正しく取得する', () async {
      when(githubContributorRepository.getContributors()).thenAnswer((_) async => <GitHubProfile>[]);

      final service = GitHubContributorService(githubContributorRepository);

      final result = await service.getContributors();

      expect(result, isEmpty);

      verify(githubContributorRepository.getContributors()).called(1);
    });
  });

  group('GitHubContributorService 異常系', () {
    test('getContributors がリポジトリの例外をそのまま伝播する', () async {
      when(githubContributorRepository.getContributors()).thenThrow(Exception('Failed to get contributors'));

      final service = GitHubContributorService(githubContributorRepository);

      expect(() => service.getContributors(), throwsA(isA<Exception>()));

      verify(githubContributorRepository.getContributors()).called(1);
    });
  });
}
