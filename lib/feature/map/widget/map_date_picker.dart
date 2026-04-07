import 'package:dotto/helper/date_formatter.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

final class MapDatePicker extends StatelessWidget {
  const MapDatePicker({
    required this.searchDatetime,
    required this.onPeriodButtonTapped,
    required this.onDatePickerConfirmed,
    super.key,
  });
  final DateTime searchDatetime;
  final void Function(DateTime) onPeriodButtonTapped;
  final void Function(DateTime) onDatePickerConfirmed;

  Widget _periodButton(BuildContext context, String label, DateTime dateTime) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: searchDatetime == dateTime ? Colors.black12 : null,
        textStyle: Theme.of(context).textTheme.labelMedium,
        padding: EdgeInsets.zero,
      ),
      onPressed: () => onPeriodButtonTapped(dateTime),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: searchDatetime == dateTime ? SemanticColor.light.accentPrimary : SemanticColor.light.labelSecondary,
        ),
      ),
    );
  }

  Widget _datePickerButton(BuildContext context, DateTime searchDatetime, DateTime monday, DateTime nextSunday) {
    return TextButton(
      style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelMedium, padding: EdgeInsets.zero),
      onPressed: () async {
        final locale = WidgetsBinding.instance.platformDispatcher.locale;
        await DatePicker.showDateTimePicker(
          context,
          minTime: monday,
          maxTime: nextSunday,
          onConfirm: onDatePickerConfirmed,
          currentTime: searchDatetime,
          locale: locale,
        );
      },
      child: Column(
        children: [
          Text(DateFormatter.dateWithoutYear(searchDatetime)),
          Text(DateFormatter.timeWithoutSecond(searchDatetime)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final nextSunday = monday.add(const Duration(days: 14, minutes: -1));
    final timeMap = <String, DateTime>{
      '1限': today.add(const Duration(hours: 9)),
      '2限': today.add(const Duration(hours: 10, minutes: 40)),
      '3限': today.add(const Duration(hours: 13, minutes: 10)),
      '4限': today.add(const Duration(hours: 14, minutes: 50)),
      '5限': today.add(const Duration(hours: 16, minutes: 30)),
      '現在': today,
    };

    return Row(
      children: [
        ...timeMap.entries.map((item) => Expanded(child: Center(child: _periodButton(context, item.key, item.value)))),
        _datePickerButton(context, searchDatetime, monday, nextSunday),
      ],
    );
  }
}
