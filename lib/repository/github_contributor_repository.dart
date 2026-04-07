import 'package:dio/dio.dart';
import 'package:dotto/domain/domain_error.dart';
import 'package:dotto/domain/github_profile.dart';
import 'package:dotto/repository/model/github_profile_response.dart';

abstract class GitHubContributorRepository {
  Future<List<GitHubProfile>> getContributors();
}

final class GitHubContributorRepositoryImpl
    implements GitHubContributorRepository {
  GitHubContributorRepositoryImpl();

  @override
  Future<List<GitHubProfile>> getContributors() async {
    try {
      final dio = Dio();
      // GitHub contributors API for this repository
      const url = 'https://api.github.com/repos/fun-dotto/dotto/contributors';

      //
      // ignore: inference_failure_on_function_invocation
      final response = await dio.get(url);
      if (response.statusCode != 200) {
        throw const DomainError(
          type: DomainErrorType.invalidResponse,
          message: 'Failed to get contributors',
        );
      }

      final data = response.data;
      if (data == null || data is! List) {
        throw const DomainError(
          type: DomainErrorType.invalidResponse,
          message: 'Failed to get contributors',
        );
      }

      final githubProfileResponses = data
          .map((e) => GitHubProfileResponse.fromJson(e as Map<String, dynamic>))
          .toList();

      return githubProfileResponses
          .map(
            (e) => GitHubProfile(
              id: e.id.toString(),
              login: e.login,
              avatarUrl: e.avatarUrl,
              htmlUrl: e.htmlUrl,
              contributions: e.contributions,
            ),
          )
          .toList();
    } on DomainError {
      rethrow;
    } on Exception catch (e, stackTrace) {
      throw DomainError.fromException(e: e, stackTrace: stackTrace);
    }
  }
}
