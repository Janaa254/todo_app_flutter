import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

import '../core/colors/app_colors.dart';

class DateTimelineWidget extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChange;

  const DateTimelineWidget({
    super.key,
    required this.selectedDate,
    required this.onDateChange,
  });

  @override
  State<DateTimelineWidget> createState() =>
      _DateTimelineWidgetState();
}

class _DateTimelineWidgetState
    extends State<DateTimelineWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightBackground,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: EasyDateTimeLine(
        initialDate: widget.selectedDate,
        activeColor: AppColors.primary,

        dayProps: const EasyDayProps(
          width: 60,
          height: 80,
        ),

        headerProps: const EasyHeaderProps(
          showHeader: false,
        ),

        onDateChange: widget.onDateChange,
      ),
    );
  }
}