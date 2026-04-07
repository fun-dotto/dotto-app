import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotto/asset.dart';
import 'package:dotto/feature/funch/controller/funch_mypage_card_index_controller.dart';
import 'package:dotto/feature/funch/controller/funch_today_daily_menu_controller.dart';
import 'package:dotto/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/funch/funch.dart';
import 'package:dotto/feature/funch/widget/funch_price_list.dart';
import 'package:dotto/helper/date_formatter.dart';
import 'package:dotto/helper/datetime.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

final class FunchMyPageCard extends ConsumerWidget {
  const FunchMyPageCard({super.key});

  ImageProvider<Object> _getBackgroundImage(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return NetworkImage(imageUrl);
    } else {
      return const AssetImage(Asset.noImage);
    }
  }

  Widget _buildEmptyCard(BuildContext context, DateTime date) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: Text('情報が見つかりません')),
    );
  }

  Widget _buildCarouselItem(BuildContext context, FunchMenu menu) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image(
            image: _getBackgroundImage(menu.imageUrl),
            width: double.infinity,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                Asset.noImage,
                width: double.infinity,
                fit: BoxFit.fill,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(menu.name, style: Theme.of(context).textTheme.titleMedium),
              Divider(height: 2, color: SemanticColor.light.borderPrimary),
              const SizedBox(height: 5),
              FunchPriceList(menu, isHome: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselIndicators(
    BuildContext context,
    WidgetRef ref,
    List<FunchMenu> menuItems,
  ) {
    final selectedIndex = ref.watch(funchMyPageCardIndexProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: menuItems.map((menu) {
          final index = menuItems.indexOf(menu);
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withValues(alpha: selectedIndex == index ? 0.9 : 0.4),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCarousel(
    BuildContext context,
    WidgetRef ref,
    List<FunchMenu> menuItems,
  ) {
    return Column(
      spacing: 8,
      children: [
        CarouselSlider(
          items: menuItems
              .map((menu) => _buildCarouselItem(context, menu))
              .toList(),
          options: CarouselOptions(
            aspectRatio: 4 / 3,
            autoPlay: true,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              ref.read(funchMyPageCardIndexProvider.notifier).value = index;
            },
          ),
        ),
        _buildCarouselIndicators(context, ref, menuItems),
      ],
    );
  }

  Widget _buildMenuCard(BuildContext context, WidgetRef ref) {
    final date = DateTimeUtility.startOfDay(DateTime.now());
    final funchDailyMenuList = ref.watch(funchTodayDailyMenuListProvider);

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text('${DateFormatter.dateWithoutYear(date)}の学食'),
            funchDailyMenuList.when(
              data: (data) {
                final menuItems = data[DateFormatter.date(date)]?.menuItems;
                if (menuItems == null) {
                  return _buildEmptyCard(context, date);
                }
                if (menuItems.isEmpty) {
                  return _buildEmptyCard(context, date);
                }
                return _buildCarousel(context, ref, menuItems);
              },
              error: (error, stackTrace) => _buildEmptyCard(context, date),
              loading: () => Shimmer(child: Container(color: Colors.grey)),
            ),
            Text(
              'メニューは変更される可能性があります',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: SemanticColor.light.labelSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const FunchScreen(),
            // TODO(kantacky): Home廃止に伴う変更
            settings: const RouteSettings(name: '/home/funch'),
          ),
        );
      },
      child: _buildMenuCard(context, ref),
    );
  }
}
