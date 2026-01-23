import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trax_host_portal/helper/app_padding.dart';
import 'package:trax_host_portal/models/event.dart';
import 'package:trax_host_portal/theme/app_font_weight.dart';
import 'package:trax_host_portal/theme/styled_app_text.dart';
import 'package:trax_host_portal/utils/enums/sizes.dart';

class ThirdSection extends StatelessWidget {
  final Event event;

  const ThirdSection({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.all(context, paddingType: Sizes.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: AppText.styledBodyMedium(
              context,
              DateFormat('EEE, MMM d, y').format(_getEventDateTime(event)),
              weight: AppFontWeight.semiBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: AppText.styledBodyMedium(
              context,
              DateFormat(' • h:mm a').format(_getEventDateTime(event)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ), // Add your widgets for the third section here
        ],
      ),
    );
  }

  /// Helper method to combine event date and start time into DateTime
  DateTime _getEventDateTime(Event event) {
    return DateTime(
      event.date.year,
      event.date.month,
      event.date.day,
      event.startTime.hour,
      event.startTime.minute,
    );
  }
}
