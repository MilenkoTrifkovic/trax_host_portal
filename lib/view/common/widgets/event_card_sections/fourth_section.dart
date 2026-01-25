import 'package:flutter/material.dart';
import 'package:trax_host_portal/models/event.dart';
import 'package:trax_host_portal/theme/app_font_weight.dart';
import 'package:trax_host_portal/theme/styled_app_text.dart';
import 'package:trax_host_portal/utils/enums/event_status.dart';
import 'package:velocity_x/velocity_x.dart';

class FourthSection extends StatelessWidget {
  final Event event;

  const FourthSection({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: event.status.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: AppText.styledBodyMedium(
                context,
                event.status.name.capitalized,
                weight: AppFontWeight.semiBold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
