import 'package:dotto/domain/announcement.dart';
import 'package:dotto/domain/domain_error.dart';
import 'package:dotto/feature/announcement/announcement_action.dart';
import 'package:dotto/feature/announcement/announcement_reducer.dart';
import 'package:dotto/feature/announcement/announcement_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testAnnouncements = [
    Announcement(
      id: '1',
      title: 'お知らせ1',
      date: DateTime(2025),
      url: 'https://example.com/announcement1',
    ),
    Announcement(
      id: '2',
      title: 'お知らせ2',
      date: DateTime(2025, 1, 2),
      url: 'https://example.com/announcement2',
    ),
  ];

  group('announcementReduce', () {
    test('初期状態はローディングかつ fetchEpoch=0', () {
      final state = AnnouncementState.initial();

      expect(state.announcements.isLoading, isTrue);
      expect(state.fetchEpoch, 0);
    });

    test('refreshRequested でローディングに戻り fetchEpoch が加算される', () {
      final state = AnnouncementState.initial().copyWith(
        announcements: AsyncValue.data(testAnnouncements),
      );

      final next = announcementReduce(
        state,
        const AnnouncementAction.refreshRequested(),
      );

      expect(next.announcements.isLoading, isTrue);
      expect(next.fetchEpoch, state.fetchEpoch + 1);
    });

    test('announcementsLoaded でデータが格納される', () {
      final state = AnnouncementState.initial();

      final next = announcementReduce(
        state,
        AnnouncementAction.announcementsLoaded(testAnnouncements),
      );

      expect(next.announcements.hasValue, isTrue);
      expect(next.announcements.value, testAnnouncements);
      expect(next.fetchEpoch, state.fetchEpoch);
    });

    test('announcementsFailed でエラーが格納される', () {
      const error = DomainError(
        type: DomainErrorType.invalidResponse,
        message: 'Failed to get announcements',
      );
      final state = AnnouncementState.initial();

      final next = announcementReduce(
        state,
        const AnnouncementAction.announcementsFailed(error),
      );

      expect(next.announcements.hasError, isTrue);
      expect(next.announcements.error, error);
    });
  });
}
