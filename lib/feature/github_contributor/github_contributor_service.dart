import 'package:dotto/domain/github_profile.dart';
import 'package:dotto/repository/github_contributor_repository.dart';

final class GitHubContributorService {
  GitHubContributorService(this.gitHubContributorRepository);

  final GitHubContributorRepository gitHubContributorRepository;

  Future<List<GitHubProfile>> getContributors() async {
    final contributors = await gitHubContributorRepository.getContributors();
    contributors.sort((a, b) => b.contributions.compareTo(a.contributions));
    return contributors;
  }
}
