import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/announcement.dart';
import 'package:dotto/domain/domain_error.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final announcementRepositoryProvider = Provider<AnnouncementRepository>(
  AnnouncementRepositoryImpl.new,
);

abstract class AnnouncementRepository {
  Future<List<Announcement>> getAnnouncements();
}

final class AnnouncementRepositoryImpl implements AnnouncementRepository {
  AnnouncementRepositoryImpl(this.ref);

  final Ref ref;

  @override
  Future<List<Announcement>> getAnnouncements() async {
    try {
      final api = ref.read(apiClientProvider).getAnnouncementsApi();
      final response = await api.announcementsV1List();
      if (response.statusCode != 200) {
        throw const DomainError(
          type: DomainErrorType.invalidResponse,
          message: 'Failed to get announcements',
        );
      }
      final data = response.data;
      if (data == null) {
        throw const DomainError(
          type: DomainErrorType.invalidResponse,
          message: 'Failed to get announcements',
        );
      }
      return data.announcements
          .map(
            (e) => Announcement(
              id: e.id,
              title: e.title,
              date: e.date,
              url: e.url,
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
