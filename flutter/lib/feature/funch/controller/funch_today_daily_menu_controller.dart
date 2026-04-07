import 'package:collection/collection.dart';
import 'package:dotto/feature/funch/domain/funch_daily_menu.dart';
import 'package:dotto/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/funch/repository/funch_repository.dart';
import 'package:dotto/helper/date_formatter.dart';
import 'package:dotto/helper/datetime.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final funchTodayDailyMenuListProvider =
    AsyncNotifierProvider<
      FunchTodayDailyMenuNotifier,
      Map<String, FunchDailyMenu>
    >(() => FunchTodayDailyMenuNotifier(FunchRepositoryImpl()));

final class FunchTodayDailyMenuNotifier<
  FunchRepository extends FunchRepositoryInterface
>
    extends AsyncNotifier<Map<String, FunchDailyMenu>> {
  FunchTodayDailyMenuNotifier(this._funchRepository);
  final FunchRepository _funchRepository;

  @override
  Future<Map<String, FunchDailyMenu>> build() async {
    try {
      final allCommonMenu = await _funchRepository.getAllCommonMenu();
      final allOriginalMenu = await _funchRepository.getAllOriginalMenu();

      final from = DateTimeUtility.startOfDay(DateTime.now());
      final to = DateTimeUtility.startOfDay(from);

      final monthlyMenuFromFirestore = await _funchRepository
          .getMenuFromFirestore(MenuCollection.monthly, from, to);
      final dailyMenuFromFirestore = await _funchRepository
          .getMenuFromFirestore(MenuCollection.daily, from, to);

      final combinedMenus = <String, FunchDailyMenu>{};

      for (final dateString in dailyMenuFromFirestore.keys) {
        final menuItems = <FunchMenu>[];
        final date = DateTimeUtility.parseDate(dateString);
        final firstDayOfMonth = DateTimeUtility.firstDateOfMonth(date);
        final monthlyMenu =
            monthlyMenuFromFirestore[DateFormatter.date(firstDayOfMonth)];
        final dailyMenu = dailyMenuFromFirestore[DateFormatter.date(date)];

        for (final id in (monthlyMenu?.commonMenuIds ?? [])) {
          final menu = allCommonMenu.firstWhereOrNull(
            (m) => m.id == id.toString(),
          );
          if (menu != null) {
            menuItems.add(menu);
          }
        }
        for (final id in (monthlyMenu?.originalMenuIds ?? [])) {
          final menu = allOriginalMenu.firstWhereOrNull((m) => m.id == id);
          if (menu != null) {
            menuItems.add(menu);
          }
        }
        for (final id in (dailyMenu?.commonMenuIds ?? [])) {
          final menu = allCommonMenu.firstWhereOrNull(
            (m) => m.id == id.toString(),
          );
          if (menu != null) {
            menuItems.add(menu);
          }
        }
        for (final id in (dailyMenu?.originalMenuIds ?? [])) {
          final menu = allOriginalMenu.firstWhereOrNull((m) => m.id == id);
          if (menu != null) {
            menuItems.add(menu);
          }
        }
        combinedMenus[DateFormatter.date(date)] = FunchDailyMenu(menuItems);
      }

      return combinedMenus;
    } on Exception catch (e) {
      debugPrint('FunchTodayDailyMenuNotifier Error: $e');
      rethrow;
    }
  }
}
