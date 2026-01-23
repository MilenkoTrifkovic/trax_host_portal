import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trax_host_portal/controller/admin_controllers/admin_event_details_controllers/admin_event_details_controller.dart';
import 'package:trax_host_portal/helper/screen_size.dart';
// import 'package:trax_host_portal/view/admin/event_details/admin_event_details.dart'; // Commented out - not needed after removing edit button

class EventSummarySection extends StatelessWidget {
  final AdminEventDetailsController controller;

  const EventSummarySection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isPhone = ScreenSize.isPhone(context);
    final isTablet = ScreenSize.isTablet(context);

    // Responsive height based on screen size
    final double sectionHeight = isPhone ? 220 : (isTablet ? 250 : 280);
    final double padding = isPhone ? 16 : (isTablet ? 20 : 28);
    final double titleFontSize = isPhone ? 22 : (isTablet ? 26 : 32);
    final double pillFontSize = isPhone ? 11 : 13;
    final double pillIconSize = isPhone ? 14 : 16;
    final double pillPaddingH = isPhone ? 10 : 14;
    final double pillPaddingV = isPhone ? 6 : 8;

    return Obx(() {
      final evt = controller.event.value;
      if (evt == null) return const SizedBox.shrink();
      final organisation = controller.organisation;
      final venue = controller.venue;

      final dateStr =
          "${evt.date.day.toString().padLeft(2, '0')}.${evt.date.month.toString().padLeft(2, '0')}.${evt.date.year}";
      final timeStr =
          "${evt.date.hour.toString().padLeft(2, '0')}:${evt.date.minute.toString().padLeft(2, '0')}";

      // Check if event has a cover image (use downloadable URL)
      final hasCoverImage = evt.coverImageDownloadUrl != null &&
          evt.coverImageDownloadUrl!.isNotEmpty;
      return Container(
        height: sectionHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background image with overlay
            if (hasCoverImage)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Event cover image (use downloadable URL)
                      Image.network(
                        evt.coverImageDownloadUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Container(
                            color: Colors.grey.shade800,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print('IMAGE LOAD ERROR: $error');
                          print('STACK TRACE: $stackTrace');
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF1F2937),
                                  const Color(0xFF111827),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 64,
                                color: Colors.white38,
                              ),
                            ),
                          );
                        },
                      ),
                      // Dark gradient overlay for better text readability
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                      // Additional side gradient for depth
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black.withValues(alpha: 0.4),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.2),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Fallback gradient background if no image
            if (!hasCoverImage)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF1F2937),
                        const Color(0xFF111827),
                      ],
                    ),
                  ),
                ),
              ),

            // Content overlay
            Positioned.fill(
              child: Container(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with edit button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Upload/Change image button
                        Material(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(isPhone ? 8 : 12),
                          child: InkWell(
                            borderRadius:
                                BorderRadius.circular(isPhone ? 8 : 12),
                            onTap: () => controller.pickAndUploadCoverImage(),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(isPhone ? 8 : 12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: isPhone ? 10 : 14,
                                vertical: isPhone ? 6 : 8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    hasCoverImage
                                        ? Icons.edit_outlined
                                        : Icons.add_photo_alternate_outlined,
                                    size: isPhone ? 14 : 16,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: isPhone ? 6 : 8),
                                  Text(
                                    hasCoverImage
                                        ? (isPhone ? 'Cover' : 'Change Cover')
                                        : (isPhone ? 'Add' : 'Add Cover'),
                                    style: GoogleFonts.poppins(
                                      fontSize: isPhone ? 11 : 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Edit event details button - COMMENTED OUT FOR HOST VIEW
                        /* Material(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => EditEventDetailsDialog(
                                  controller: controller,
                                  initialEvent: evt,
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.settings_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ), */
                      ],
                    ),

                    const Spacer(),

                    // Event title
                    Text(
                      evt.name,
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isPhone ? 12 : 16),

                    // Info pills
                    Wrap(
                      spacing: isPhone ? 8 : 12,
                      runSpacing: isPhone ? 6 : 10,
                      children: [
                        _glassPill(
                          icon: Icons.event_outlined,
                          label: '$dateStr • $timeStr',
                          fontSize: pillFontSize,
                          iconSize: pillIconSize,
                          paddingH: pillPaddingH,
                          paddingV: pillPaddingV,
                        ),
                        _glassPill(
                          icon: Icons.place_outlined,
                          label: organisation?.city ?? 'Location not set',
                          fontSize: pillFontSize,
                          iconSize: pillIconSize,
                          paddingH: pillPaddingH,
                          paddingV: pillPaddingV,
                        ),
                        _glassPill(
                          icon: Icons.location_city_outlined,
                          label:
                              venue.value?.name.capitalize ?? 'Venue not set',
                          fontSize: pillFontSize,
                          iconSize: pillIconSize,
                          paddingH: pillPaddingH,
                          paddingV: pillPaddingV,
                        ),
                        _glassPill(
                          icon: Icons.restaurant_outlined,
                          label: evt.serviceType.name.isEmpty
                              ? 'Service type'
                              : evt.serviceType.name[0].toUpperCase() +
                                  evt.serviceType.name.substring(1),
                          fontSize: pillFontSize,
                          iconSize: pillIconSize,
                          paddingH: pillPaddingH,
                          paddingV: pillPaddingV,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Glass morphism style pill for better visibility on image backgrounds
  Widget _glassPill({
    required IconData icon,
    required String label,
    double fontSize = 13,
    double iconSize = 16,
    double paddingH = 14,
    double paddingV = 8,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
