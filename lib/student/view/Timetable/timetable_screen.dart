import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management_system/public/utils/constant.dart';
import 'package:school_management_system/public/utils/font_style.dart';
import 'package:school_management_system/student/controllers/timetable_controller.dart';

// ── Subject colors ────────────────────────────────
const List<Color> _kColors = [
  Color(0xFF5B4FCF), Color(0xFF1D9E75), Color(0xFF378ADD),
  Color(0xFFBA7517), Color(0xFFD4537E), Color(0xFF639922),
];
const List<Color> _kBgColors = [
  Color(0xFFEEEDFE), Color(0xFFE1F5EE), Color(0xFFE6F1FB),
  Color(0xFFFAEEDA), Color(0xFFFBEAF0), Color(0xFFEAF3DE),
];

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(TimetableController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Timetable',
                    style: sfMediumStyle(
                        fontSize: 18, color: Colors.white)),
                if (c.className.value.isNotEmpty)
                  Text(c.className.value,
                      style: sfRegularStyle(
                          fontSize: 11, color: Colors.white70)),
              ],
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () => c.getTimetable(),
          ),
        ],
        // ── Day selector tabs ──────────────────────
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(46.h),
          child: Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                    horizontal: 12.w, vertical: 8.h),
                child: Row(
                  children: c.days.map((day) {
                    final isSelected =
                        c.selectedDay.value == day;
                    return GestureDetector(
                      onTap: () => c.selectDay(day),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(right: 8.w),
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          day.substring(0, 3), // Mon, Tue...
                          style: sfMediumStyle(
                            fontSize: 12,
                            color: isSelected
                                ? primaryColor
                                : Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )),
        ),
      ),

      body: Obx(() {
        if (c.isLoading.value) {
          return Center(
              child: CircularProgressIndicator(color: primaryColor));
        }

        final slots = c.todaySlots;

        // ── Empty ──────────────────────────────────
        if (slots.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_available_rounded,
                    size: 56, color: Colors.grey[300]),
                SizedBox(height: 12.h),
                Text(
                  '${c.selectedDay.value} ko koi class nahi',
                  style: sfMediumStyle(
                      fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // ── Slots list ─────────────────────────────
        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: slots.length,
          itemBuilder: (_, i) {
            final slot    = slots[i];
            final color   = _kColors[i % _kColors.length];
            final bgColor = _kBgColors[i % _kBgColors.length];

            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.symmetric(
                  horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border(
                    left: BorderSide(color: color, width: 4)),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [

                  // ── Time column ─────────────────
                  SizedBox(
                    width: 62.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          slot['start_time']?.toString() ?? '',
                          style: sfMediumStyle(
                              fontSize: 11, color: color),
                        ),
                        SizedBox(height: 2.h),
                        Container(
                            height: 1,
                            color: color.withOpacity(0.3)),
                        SizedBox(height: 2.h),
                        Text(
                          slot['end_time']?.toString() ?? '',
                          style: sfRegularStyle(
                            fontSize: 10,
                            color: color.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 14.w),

                  // ── Subject info ────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          slot['subject_name']?.toString() ?? '',
                          style: sfMediumStyle(
                              fontSize: 14, color: Colors.black87),
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            // Teacher
                            Icon(Icons.person_outline,
                                size: 12, color: Colors.grey),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                slot['teacher_name']
                                        ?.toString() ??
                                    '',
                                style: sfRegularStyle(
                                    fontSize: 11,
                                    color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Room
                            if ((slot['room'] ?? '').isNotEmpty) ...[
                              SizedBox(width: 8.w),
                              Icon(Icons.room_outlined,
                                  size: 12, color: Colors.grey),
                              SizedBox(width: 3.w),
                              Text(
                                'Room ${slot['room']}',
                                style: sfRegularStyle(
                                    fontSize: 11,
                                    color: Colors.grey),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── Period badge ────────────────
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'P${i + 1}',
                      style: sfMediumStyle(
                          fontSize: 11, color: color),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}