import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../public/login/dividerforparent.dart';
import '../../../public/utils/constant.dart';
import '../../../public/utils/font_style.dart';
import '../../../routes/app_pages.dart';
import '../../controllers/home_controller.dart';

var _controller = Get.put(TeacherHomeController());

class HomeTeacher extends StatelessWidget {
  const HomeTeacher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),

          // ── Teacher Welcome Card ──────────────────
          Obx(() => _controller.isLoadingProfile.value
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: gradientColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Photo ya initials
                        Obx(() => _controller.teacherPhoto.value.isNotEmpty
                            ? CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(
                                    _controller.teacherPhoto.value),
                              )
                            : CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.white24,
                                child: Text(
                                  _controller.teacherName.value.isNotEmpty
                                      ? _controller.teacherName.value[0]
                                          .toUpperCase()
                                      : 'T',
                                  style: sfBoldStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                              )),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back,',
                              style: sfRegularStyle(
                                  fontSize: 12, color: Colors.white70),
                            ),
                            Obx(() => Text(
                                  _controller.teacherName.value,
                                  style: sfBoldStyle(
                                      fontSize: 18, color: Colors.white),
                                )),
                            Obx(() => _controller.teacherEmail.value.isNotEmpty
                                ? Text(
                                    _controller.teacherEmail.value,
                                    style: sfRegularStyle(
                                        fontSize: 11, color: Colors.white70),
                                  )
                                : const SizedBox.shrink()),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),

          const SizedBox(height: 16),

          // ── Calendar ─────────────────────────────
          Container(
            height: 255,
            width: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TableCalendar(
                rowHeight: 52,
                firstDay: DateTime.utc(2022, 7, 1),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: DateTime.now(),
                shouldFillViewport: true,
                daysOfWeekHeight: 15,
                calendarStyle: const CalendarStyle(
                  defaultTextStyle: TextStyle(fontSize: 10),
                  weekendTextStyle: TextStyle(fontSize: 10),
                  todayTextStyle: TextStyle(fontSize: 10),
                  outsideTextStyle: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // ── Timetable (Programs ki jagah) ─────────
          DividerParent(text: "Today's Timetable"),
          const SizedBox(height: 10),

          Obx(() {
            if (_controller.isLoadingTimetable.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_controller.timetableList.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: Text('No timetable found')),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: _controller.timetableList.length,
              itemBuilder: (context, index) {
                final item = _controller.timetableList[index];
                return TimetableCard(item: item);
              },
            );
          }),

          const SizedBox(height: 15),

          // ── Classes ───────────────────────────────
          const DividerParent(text: "Classes"),
          const SizedBox(height: 10),

          SizedBox(
            height: 210.h,
            child: Obx(() {
              if (_controller.isLoadingClasses.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_controller.classesList.isEmpty) {
                return const Center(child: Text('No classes found'));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _controller.classesList.length,
                itemBuilder: (context, index) {
                  final c = _controller.classesList[index];
                  return TeacherClassesCard(
                    section: c.section,
                    grade: c.grade,
                    numberOfStudents: c.numberOfstudents,
                    classId: c.classroomID,
                  );
                },
              );
            }),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── Timetable Card ────────────────────────────────────
class TimetableCard extends StatelessWidget {
  final dynamic item;
  const TimetableCard({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.schedule, color: primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['subject']?['name'] ?? 'Subject',
                  style: sfBoldStyle(fontSize: 14, color: Colors.black87),
                ),
                Text(
                  item['school_class']?['name'] ?? 'Class',
                  style: sfRegularStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            '${item['start_time'] ?? ''} - ${item['end_time'] ?? ''}',
            style: sfRegularStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ── Classes Card ──────────────────────────────────────
class TeacherClassesCard extends StatelessWidget {
  const TeacherClassesCard({
    this.section,
    this.grade,
    this.numberOfStudents,
    this.classId,
    Key? key,
  }) : super(key: key);

  final section;
  final grade;
  final numberOfStudents;
  final classId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.w, bottom: 20.h, top: 10.h),
      child: GestureDetector(
        onTap: () {
          var data = {
            'grade': grade.toString(),
            'classid': classId.toString(),
          };
          Get.toNamed(AppPages.tsubjects, parameters: data);
        },
        child: Container(
          height: 178.h,
          width: 178.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            gradient: gradientColor,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$section - $grade',
                  style: sfBoldStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 3),
                Text(
                  '$numberOfStudents students',
                  style: sfBoldStyle(fontSize: 10, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}