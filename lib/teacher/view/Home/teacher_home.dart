import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management_system/public/utils/constant.dart';
import 'package:school_management_system/public/utils/font_style.dart';
import 'package:school_management_system/routes/app_pages.dart';
import 'package:school_management_system/teacher/controllers/home_controller.dart';

class HomeTeacher extends StatelessWidget {
  const HomeTeacher({Key? key}) : super(key: key);

  static const List<Color> subjectColors = [
    Color(0xFF5B4FCF), Color(0xFF1D9E75), Color(0xFF378ADD),
    Color(0xFFBA7517), Color(0xFFD4537E), Color(0xFF639922),
  ];
  static const List<Color> subjectBgColors = [
    Color(0xFFEEEDFE), Color(0xFFE1F5EE), Color(0xFFE6F1FB),
    Color(0xFFFAEEDA), Color(0xFFFBEAF0), Color(0xFFEAF3DE),
  ];

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TeacherHomeController>();

    return Obx(() {
      if (c.isLoading.value) {
        return Center(child: CircularProgressIndicator(color: primaryColor));
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Stats Row ─────────────────────────
            _statsRow(c),
            SizedBox(height: 20.h),

            // ── Timetable ─────────────────────────
            _sectionHeaderWithMore(
              title: '🕐 Aaj Ka Timetable',
              total: c.timetableList.length,
              showAll: c.showAllTimetable,
            ),
            SizedBox(height: 8.h),
            _timetableSection(c),
            SizedBox(height: 20.h),

            // ── Classes ───────────────────────────
            _sectionHeaderWithMore(
              title: '🏫 Meri Classes',
              total: c.classesList.length,
              showAll: c.showAllClasses,
            ),
            SizedBox(height: 8.h),
            _classesSection(c),
            SizedBox(height: 20.h),

            // ── Subjects ──────────────────────────
            _sectionHeaderWithMore(
              title: '📚 Assigned Subjects',
              total: c.subjectsList.length,
              showAll: c.showAllSubjects,
            ),
            SizedBox(height: 8.h),
            _subjectsSection(c),
            SizedBox(height: 20.h),

            // ── Homework ──────────────────────────
            _sectionHeaderWithMore(
              title: '📝 Active Homework',
              total: c.homeworkList.length,
              showAll: c.showAllHomework,
            ),
            SizedBox(height: 8.h),
            _homeworkSection(c),
            SizedBox(height: 20.h),

            // ── Exams ─────────────────────────────
            if (c.examsList.isNotEmpty) ...[
              _sectionHeaderWithMore(
                title: '⚠️ Upcoming Exams',
                total: c.examsList.length,
                showAll: c.showAllExams,
              ),
              SizedBox(height: 8.h),
              _examsSection(c),
              SizedBox(height: 20.h),
            ],

            // ── Notices ───────────────────────────
            _sectionHeaderWithMore(
              title: '📢 Notices',
              total: c.noticesList.length,
              showAll: c.showAllNotices,
            ),
            SizedBox(height: 8.h),
            _noticesSection(c),

            SizedBox(height: 30.h),
          ],
        ),
      );
    });
  }

  // ═══════════════════════════════════════════════
  // SECTION HEADER — title + "2/5 • More ▼" button
  // ═══════════════════════════════════════════════
  Widget _sectionHeaderWithMore({
    required String title,
    required int total,
    required RxBool showAll,
  }) {
    final preview = TeacherHomeController.previewCount;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: sfMediumStyle(fontSize: 15, color: Colors.black87)),
        if (total > preview)
          Obx(() => GestureDetector(
                onTap: () => showAll.value = !showAll.value,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        showAll.value
                            ? 'Less ▲'
                            : '$preview/$total  More ▼',
                        style: sfRegularStyle(fontSize: 10, color: primaryColor),
                      ),
                    ],
                  ),
                ),
              )),
      ],
    );
  }

  // ═══════════════════════════════════════════════
  // STATS ROW
  // ═══════════════════════════════════════════════
  Widget _statsRow(TeacherHomeController c) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Obx(() => Row(
            children: [
              _statBox('${c.totalStudents.value}', 'Students'),
              _divider(),
              _statBox('${c.activeHomework.value}', 'Homework'),
              _divider(),
              _statBox('${c.totalExams.value}', 'Exams'),
            ],
          )),
    );
  }

  Widget _statBox(String value, String label) => Expanded(
        child: Column(children: [
          Text(value, style: sfMediumStyle(fontSize: 18, color: Colors.white)),
          SizedBox(height: 2.h),
          Text(label, style: sfRegularStyle(fontSize: 9, color: Colors.white70)),
        ]),
      );

  Widget _divider() =>
      Container(height: 30.h, width: 0.5, color: Colors.white30);

  // ═══════════════════════════════════════════════
  // TIMETABLE — horizontal colored cards
  // ═══════════════════════════════════════════════
  Widget _timetableSection(TeacherHomeController c) {
    return Obx(() {
      if (c.timetableList.isEmpty) return _emptyCard('Aaj koi class nahi');

      final items = c.visibleTimetable;
      return Column(
        children: [
          Row(
            children: items.asMap().entries.map((e) {
              int i = e.key;
              final item = e.value;
              Color color   = subjectColors[i % subjectColors.length];
              Color bgColor = subjectBgColors[i % subjectBgColors.length];
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < items.length - 1 ? 8.w : 0),
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border(left: BorderSide(color: color, width: 3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['subject_name'] ?? '',
                          style: sfMediumStyle(fontSize: 10, color: color),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      SizedBox(height: 3.h),
                      Text(
                        '${item['start_time'] ?? ''} - ${item['end_time'] ?? ''}',
                        style: sfRegularStyle(fontSize: 8, color: color.withOpacity(0.8)),
                      ),
                      SizedBox(height: 2.h),
                      Text(item['class_name'] ?? '',
                          style: sfRegularStyle(fontSize: 8, color: color.withOpacity(0.7)),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          // agar items > preview count, "More" row show karo
          if (c.timetableList.length > TeacherHomeController.previewCount &&
              c.showAllTimetable.value)
            ..._timetableExtraCards(c),
        ],
      );
    });
  }

  List<Widget> _timetableExtraCards(TeacherHomeController c) {
    final extra = c.timetableList
        .skip(TeacherHomeController.previewCount)
        .toList();
    return extra.asMap().entries.map((e) {
      final i    = e.key + TeacherHomeController.previewCount;
      final item = e.value;
      Color color   = subjectColors[i % subjectColors.length];
      Color bgColor = subjectBgColors[i % subjectBgColors.length];
      return Container(
        margin: EdgeInsets.only(top: 8.h),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: color, width: 3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(item['subject_name'] ?? '',
                  style: sfMediumStyle(fontSize: 11, color: color)),
            ),
            Text(
              '${item['start_time'] ?? ''} - ${item['end_time'] ?? ''}',
              style: sfRegularStyle(fontSize: 10, color: color.withOpacity(0.8)),
            ),
          ],
        ),
      );
    }).toList();
  }

  // ═══════════════════════════════════════════════
  // CLASSES — horizontal scroll (2 visible, more on tap)
  // ═══════════════════════════════════════════════
  Widget _classesSection(TeacherHomeController c) {
    return Obx(() {
      if (c.classesList.isEmpty) return _emptyCard('Koi class nahi');

      final items = c.visibleClasses;
      return _horizontalChips(
        items: items,
        titleKey: (item) => '${item.section} - ${item.grade}',
        subtitleKey: (item) => '${item.numberOfstudents} students',
        onTap: (item) => Get.toNamed(AppPages.tsubjects, parameters: {
          'grade':   item.grade.toString(),
          'classid': item.classroomID.toString(),
        }),
        colorIndex: (i) => i,
      );
    });
  }

  // ═══════════════════════════════════════════════
  // SUBJECTS — horizontal scroll
  // ═══════════════════════════════════════════════
  Widget _subjectsSection(TeacherHomeController c) {
    return Obx(() {
      if (c.subjectsList.isEmpty) return _emptyCard('Koi subject assign nahi');

      final items = c.visibleSubjects;
      return SizedBox(
        height: 80.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (_, i) {
            final sub    = items[i];
            Color color   = subjectColors[i % subjectColors.length];
            Color bgColor = subjectBgColors[i % subjectBgColors.length];
            return Container(
              width: 100.w,
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border(top: BorderSide(color: color, width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(sub['name'] ?? '',
                      style: sfMediumStyle(fontSize: 11, color: color),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4.h),
                  Text(sub['class_name'] ?? '',
                      style: sfRegularStyle(fontSize: 9, color: color.withOpacity(0.8)),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  // ═══════════════════════════════════════════════
  // HOMEWORK LIST
  // ═══════════════════════════════════════════════
  Widget _homeworkSection(TeacherHomeController c) {
    return Obx(() {
      if (c.homeworkList.isEmpty) return _emptyCard('Koi homework nahi');
      return Column(
        children: c.visibleHomework.map((hw) => _homeworkCard(
              title:   hw['title'] ?? '',
              subject: hw['subject_name'] ?? hw['description'] ?? '',
              dueDate: hw['due_date'] ?? '',
            )).toList(),
      );
    });
  }

  // ═══════════════════════════════════════════════
  // EXAMS LIST
  // ═══════════════════════════════════════════════
  Widget _examsSection(TeacherHomeController c) {
    return Obx(() {
      if (c.examsList.isEmpty) return const SizedBox.shrink();
      return Column(
        children: c.visibleExams.map((exam) => _examAlertCard(
              title:   exam['title'] ?? exam['name'] ?? '',
              subject: exam['subject_name'] ?? '',
              date:    exam['exam_date'] ?? exam['date'] ?? '',
              marks:   exam['total_marks']?.toString() ?? '',
            )).toList(),
      );
    });
  }

  // ═══════════════════════════════════════════════
  // NOTICES LIST
  // ═══════════════════════════════════════════════
  Widget _noticesSection(TeacherHomeController c) {
    return Obx(() {
      if (c.noticesList.isEmpty) return _emptyCard('Koi notice nahi');
      return Column(
        children: c.visibleNotices.map((n) => _noticeCard(
              title:   n['title'] ?? '',
              content: n['content'] ?? n['message'] ?? '',
            )).toList(),
      );
    });
  }

  // ═══════════════════════════════════════════════
  // REUSABLE — horizontal chip list for classes
  // ═══════════════════════════════════════════════
  Widget _horizontalChips({
    required List items,
    required String Function(dynamic) titleKey,
    required String Function(dynamic) subtitleKey,
    required void Function(dynamic) onTap,
    required int Function(int) colorIndex,
  }) {
    return SizedBox(
      height: 80.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (_, i) {
          final ci      = colorIndex(i);
          Color color   = subjectColors[ci % subjectColors.length];
          Color bgColor = subjectBgColors[ci % subjectBgColors.length];
          return GestureDetector(
            onTap: () => onTap(items[i]),
            child: Container(
              width: 100.w,
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border(top: BorderSide(color: color, width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(titleKey(items[i]),
                      style: sfMediumStyle(fontSize: 11, color: color),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4.h),
                  Text(subtitleKey(items[i]),
                      style: sfRegularStyle(fontSize: 9, color: color.withOpacity(0.8))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // CARDS
  // ═══════════════════════════════════════════════
  Widget _homeworkCard({
    required String title,
    required String subject,
    required String dueDate,
  }) {
    bool isUrgent = false;
    try {
      isUrgent = DateTime.parse(dueDate).difference(DateTime.now()).inDays <= 1;
    } catch (_) {}

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w, height: 36.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.assignment_outlined,
                color: Color(0xFFBA7517), size: 18),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: sfMediumStyle(fontSize: 12, color: Colors.black87),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              SizedBox(height: 2.h),
              Text(subject,
                  style: sfRegularStyle(fontSize: 10, color: Colors.grey)),
            ]),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: isUrgent ? const Color(0xFFFCEBEB) : const Color(0xFFE1F5EE),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              dueDate.length >= 10 ? dueDate.substring(5) : dueDate,
              style: sfRegularStyle(
                  fontSize: 9,
                  color: isUrgent ? const Color(0xFFA32D2D) : const Color(0xFF085041)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _examAlertCard({
    required String title,
    required String subject,
    required String date,
    required String marks,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFCEBEB),
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: Color(0xFFE24B4A), width: 4)),
      ),
      child: Row(
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 22)),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: sfMediumStyle(fontSize: 12, color: const Color(0xFF501313))),
              SizedBox(height: 3.h),
              Text(marks.isNotEmpty ? '$subject • $marks marks' : subject,
                  style: sfRegularStyle(fontSize: 10, color: const Color(0xFFA32D2D))),
            ]),
          ),
          Text(date.length >= 10 ? date.substring(5) : date,
              style: sfRegularStyle(fontSize: 10, color: const Color(0xFFA32D2D))),
        ],
      ),
    );
  }

  Widget _noticeCard({required String title, required String content}) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F1FB),
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: Color(0xFF378ADD), width: 3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: sfMediumStyle(fontSize: 12, color: const Color(0xFF042C53))),
        if (content.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(content,
              style: sfRegularStyle(fontSize: 10, color: const Color(0xFF185FA5)),
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ]),
    );
  }

  Widget _emptyCard(String msg) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Text(msg,
          textAlign: TextAlign.center,
          style: sfRegularStyle(fontSize: 12, color: Colors.grey)),
    );
  }
}