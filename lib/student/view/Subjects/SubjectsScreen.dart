import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management_system/public/utils/constant.dart';
import 'package:school_management_system/public/utils/font_style.dart';
import 'package:school_management_system/student/controllers/subject_controller.dart';

// ─── Color palette ────────────────────────────────────
const List<Color> kSubjectColors = [
  Color(0xFF5B4FCF), Color(0xFF1D9E75), Color(0xFF378ADD),
  Color(0xFFBA7517), Color(0xFFD4537E), Color(0xFF639922),
];
const List<Color> kSubjectBgColors = [
  Color(0xFFEEEDFE), Color(0xFFE1F5EE), Color(0xFFE6F1FB),
  Color(0xFFFAEEDA), Color(0xFFFBEAF0), Color(0xFFEAF3DE),
];

// ══════════════════════════════════════════════════════
// SCREEN 1 — Subjects List
// ══════════════════════════════════════════════════════
class SubjectsScreen extends StatelessWidget {
  SubjectsScreen({Key? key, this.subjectId}) : super(key: key);
  final String? subjectId;

  @override
  Widget build(BuildContext context) {
    final c = Get.put(StudentSubjectController());

    // Agar subjectId aaya → seedha detail screen
    if (subjectId != null) {
      return SubjectDetailScreen(subjectId: subjectId!);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Subjects',
                    style: sfMediumStyle(fontSize: 18, color: Colors.white)),
                if (c.className.value.isNotEmpty)
                  Text(c.className.value,
                      style: sfRegularStyle(fontSize: 11, color: Colors.white70)),
              ],
            )),
      ),
      body: Obx(() {
        // ── Loading ──────────────────────────────────
        if (c.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        // ── Empty ────────────────────────────────────
        if (c.subjects.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book_outlined, size: 56, color: Colors.grey[300]),
                SizedBox(height: 12.h),
                Text('Koi subject nahi mila',
                    style: sfMediumStyle(fontSize: 15, color: Colors.grey)),
                SizedBox(height: 6.h),
                Text('Admin se contact karo',
                    style: sfRegularStyle(fontSize: 12, color: Colors.grey[400]!)),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () => c.getMySubjects(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Retry',
                      style: sfRegularStyle(fontSize: 13, color: Colors.white)),
                ),
              ],
            ),
          );
        }

        // ── Subjects List — ek row mein ek card ──────
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          itemCount: c.subjects.length,
          itemBuilder: (_, i) {
            final sub     = c.subjects[i];
            final color   = kSubjectColors[i % kSubjectColors.length];
            final bgColor = kSubjectBgColors[i % kSubjectBgColors.length];

            return GestureDetector(
              onTap: () => Get.to(
                () => SubjectDetailScreen(
                  subjectId: sub['id'].toString(),
                  subjectName: sub['name'] ?? '',
                  color: color,
                  bgColor: bgColor,
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border(left: BorderSide(color: color, width: 4)),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [

                    // ── Left: Icon circle ──────────────
                    Container(
                      width: 46.w,
                      height: 46.w,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          // Subject name ka pehla letter
                          (sub['name'] ?? 'S').toString().substring(0, 1).toUpperCase(),
                          style: sfMediumStyle(fontSize: 18, color: color),
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),

                    // ── Middle: Subject info ───────────
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Subject name
                          Text(
                            sub['name'] ?? '',
                            style: sfMediumStyle(fontSize: 14, color: color),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 3.h),

                          // Teacher name
                          if ((sub['teacher_name'] ?? '').isNotEmpty)
                            Row(
                              children: [
                                Icon(Icons.person_outline,
                                    size: 12, color: color.withOpacity(0.6)),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Text(
                                    sub['teacher_name'],
                                    style: sfRegularStyle(
                                        fontSize: 11,
                                        color: color.withOpacity(0.75)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 6.h),

                          // Days chips + homework badge row
                          Row(
                            children: [

                              // Days chips
                              if ((sub['days'] as List? ?? []).isNotEmpty)
                                ...(sub['days'] as List)
                                    .take(4)
                                    .map((day) => Container(
                                          margin: EdgeInsets.only(right: 4.w),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6.w, vertical: 2.h),
                                          decoration: BoxDecoration(
                                            color: color.withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            day.toString().length >= 3
                                                ? day.toString().substring(0, 3)
                                                : day.toString(),
                                            style: sfRegularStyle(
                                                fontSize: 9, color: color),
                                          ),
                                        ))
                                    .toList(),

                              const Spacer(),

                              // Active homework badge
                              if ((sub['active_homework'] ?? 0) > 0)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 7.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.assignment_outlined,
                                          size: 10, color: color),
                                      SizedBox(width: 3.w),
                                      Text(
                                        '${sub['active_homework']} HW',
                                        style: sfRegularStyle(
                                            fontSize: 9, color: color),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ── Right: Arrow icon ──────────────
                    SizedBox(width: 8.w),
                    Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// ══════════════════════════════════════════════════════
// SCREEN 2 — Subject Detail (Homework + Timetable tabs)
// ══════════════════════════════════════════════════════
class SubjectDetailScreen extends StatefulWidget {
  final String subjectId;
  final String subjectName;
  final Color color;
  final Color bgColor;

  const SubjectDetailScreen({
    Key? key,
    required this.subjectId,
    this.subjectName = '',
    this.color       = const Color(0xFF5B4FCF),
    this.bgColor     = const Color(0xFFEEEDFE),
  }) : super(key: key);

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late StudentSubjectController c;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    c = Get.find<StudentSubjectController>();
    c.getHomework(widget.subjectId);
    c.getTimetable(widget.subjectId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: widget.color,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Obx(() => Text(
              c.subjectName.value.isNotEmpty
                  ? c.subjectName.value
                  : widget.subjectName,
              style: sfMediumStyle(fontSize: 18, color: Colors.white),
            )),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.assignment_outlined, size: 16),
                  SizedBox(width: 6.w),
                  Text('Homework', style: sfMediumStyle(fontSize: 13)),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.schedule_outlined, size: 16),
                  SizedBox(width: 6.w),
                  Text('Timetable', style: sfMediumStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _HomeworkTab(controller: c, color: widget.color),
          _TimetableTab(controller: c, color: widget.color),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// TAB 1 — Homework
// ══════════════════════════════════════════════════════
class _HomeworkTab extends StatelessWidget {
  final StudentSubjectController controller;
  final Color color;
  const _HomeworkTab({required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isDetailLoading.value) {
        return Center(child: CircularProgressIndicator(color: color));
      }

      if (controller.homework.isEmpty) {
        return _emptyState(
          icon: Icons.assignment_outlined,
          message: 'Koi homework nahi',
          color: color,
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: controller.homework.length,
        itemBuilder: (_, i) {
          final hw        = controller.homework[i];
          final isOverdue = hw['is_overdue'] == true;
          final dueDate   = hw['due_date']?.toString() ?? '';

          return Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isOverdue
                    ? const Color(0xFFF09595)
                    : const Color(0xFFE8E8E8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(hw['title'] ?? '',
                          style: sfMediumStyle(fontSize: 13, color: Colors.black87)),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: isOverdue
                            ? const Color(0xFFFCEBEB)
                            : const Color(0xFFE1F5EE),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isOverdue ? 'Overdue' : 'Active',
                        style: sfRegularStyle(
                          fontSize: 9,
                          color: isOverdue
                              ? const Color(0xFFA32D2D)
                              : const Color(0xFF085041),
                        ),
                      ),
                    ),
                  ],
                ),
                if ((hw['description'] ?? '').isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  Text(hw['description'],
                      style: sfRegularStyle(fontSize: 11, color: Colors.grey[600]!),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
                SizedBox(height: 8.h),
                const Divider(height: 1, color: Color(0xFFE8E8E8)),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 13, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(hw['teacher_name'] ?? '',
                        style: sfRegularStyle(fontSize: 10, color: Colors.grey)),
                    const Spacer(),
                    Icon(Icons.calendar_today_outlined, size: 13, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      dueDate.length >= 10 ? dueDate.substring(0, 10) : dueDate,
                      style: sfRegularStyle(
                          fontSize: 10,
                          color: isOverdue
                              ? const Color(0xFFA32D2D)
                              : Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

// ══════════════════════════════════════════════════════
// TAB 2 — Timetable
// ══════════════════════════════════════════════════════
class _TimetableTab extends StatelessWidget {
  final StudentSubjectController controller;
  final Color color;
  const _TimetableTab({required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isDetailLoading.value) {
        return Center(child: CircularProgressIndicator(color: color));
      }

      if (controller.timetable.isEmpty) {
        return _emptyState(
          icon: Icons.schedule_outlined,
          message: 'Koi timetable nahi',
          color: color,
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: controller.timetable.length,
        itemBuilder: (_, i) {
          final t = controller.timetable[i];

          return Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8E8E8)),
            ),
            child: Row(
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (t['day'] ?? '').toString().length >= 3
                            ? t['day'].toString().substring(0, 3)
                            : t['day'] ?? '',
                        style: sfMediumStyle(fontSize: 13, color: color),
                      ),
                      if ((t['period_number'] ?? '').toString().isNotEmpty)
                        Text(
                          'P${t['period_number']}',
                          style: sfRegularStyle(
                              fontSize: 9, color: color.withOpacity(0.7)),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.access_time_outlined, size: 13, color: color),
                          SizedBox(width: 4.w),
                          Text(
                            '${t['start_time']} - ${t['end_time']}',
                            style: sfMediumStyle(fontSize: 13, color: Colors.black87),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.person_outline, size: 13, color: Colors.grey),
                          SizedBox(width: 4.w),
                          Text(t['teacher_name'] ?? '',
                              style: sfRegularStyle(
                                  fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                      if ((t['room'] ?? '').isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(Icons.room_outlined, size: 13, color: Colors.grey),
                            SizedBox(width: 4.w),
                            Text('Room ${t['room']}',
                                style: sfRegularStyle(
                                    fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

// ── Shared empty state widget ─────────────────────────
Widget _emptyState({
  required IconData icon,
  required String message,
  required Color color,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 52, color: Colors.grey[300]),
        SizedBox(height: 12),
        Text(message,
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'RedHatDisplay')),
      ],
    ),
  );
}