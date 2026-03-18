import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:school_management_system/student/controllers/home_controller.dart';
import 'package:school_management_system/public/utils/constant.dart';
import 'package:school_management_system/public/utils/font_style.dart';
import 'package:school_management_system/student/view/Subjects/SubjectsScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();

    return Obx(() {
      if (c.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Calendar ──────────────────────────
            _sectionTitle('📅 Calendar'),
            SizedBox(height: 8.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2022, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: DateTime.now(),
                rowHeight: 40,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // ── Subjects ──────────────────────────
            _sectionTitle('📚 Subjects'),
            SizedBox(height: 8.h),
            SizedBox(
              height: 120.h,
              child: c.subjects.isEmpty
                  ? _emptyWidget('No subjects found')
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: c.subjects.length,
                      itemBuilder: (_, i) {
                        final sub = c.subjects[i];
                        return GestureDetector(
                          // ✅ Subject pe tap karo
                          onTap: () {
                            Get.to(() => SubjectsScreen(
                              subjectId: sub['id'].toString(),
                            ));
                          },
                          child: Container(
                            width: 130.w,
                            margin: EdgeInsets.only(right: 12.w),
                            decoration: BoxDecoration(
                              gradient: gradientColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(sub['name'] ?? '',
                                    style: sfMediumStyle(
                                        fontSize: 13, color: Colors.white),
                                    maxLines: 2),
                                SizedBox(height: 6.h),
                                Text(sub['teacher_name'] ?? '',
                                    style: sfRegularStyle(
                                        fontSize: 10,
                                        color: Colors.white70),
                                    maxLines: 1),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 20.h),

            // ── Homework ──────────────────────────
            _sectionTitle('📝 Upcoming Homework'),
            SizedBox(height: 8.h),
            c.homework.isEmpty
                ? _emptyWidget('No homework')
                : Column(
                    children: c.homework.map((hw) {
                      return _listCard(
                        icon: Icons.assignment,
                        title: hw['title'] ?? '',
                        subtitle: hw['subject'] ?? '',
                        trailing: hw['due_date'] ?? '',
                        color: Colors.orange,
                      );
                    }).toList(),
                  ),
            SizedBox(height: 20.h),

            // ── Exams ─────────────────────────────
            _sectionTitle('📋 Upcoming Exams'),
            SizedBox(height: 8.h),
            c.exams.isEmpty
                ? _emptyWidget('No upcoming exams')
                : Column(
                    children: c.exams.map((exam) {
                      return _listCard(
                        icon: Icons.quiz,
                        title: exam['title'] ?? '',
                        subtitle: exam['subject'] ?? '',
                        trailing: exam['exam_date'] ?? '',
                        color: Colors.red,
                      );
                    }).toList(),
                  ),
            SizedBox(height: 20.h),

            // ── Notices ───────────────────────────
            _sectionTitle('📢 Notices'),
            SizedBox(height: 8.h),
            c.notices.isEmpty
                ? _emptyWidget('No notices')
                : Column(
                    children: c.notices.map((n) {
                      return _listCard(
                        icon: Icons.notifications,
                        title: n['title'] ?? '',
                        subtitle: n['type'] ?? '',
                        trailing: n['date'] != null
                            ? n['date'].toString().substring(0, 10)
                            : '',
                        color: Colors.blue,
                      );
                    }).toList(),
                  ),
            SizedBox(height: 20.h),

            // ── Fee Status ────────────────────────
            _sectionTitle('💰 Fee Status'),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _feeBox('Total',   c.feeTotal.value,   Colors.blue),
                  _feeBox('Paid',    c.feePaid.value,    Colors.green),
                  _feeBox('Pending', c.feePending.value, Colors.red),
                ],
              ),
            ),
            SizedBox(height: 30.h),

          ],
        ),
      );
    });
  }

  // ── Helper Widgets ────────────────────────────

  Widget _sectionTitle(String title) {
    return Text(title,
        style: sfMediumStyle(fontSize: 16, color: Colors.black87));
  }

  Widget _emptyWidget(String msg) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(msg,
            style: sfRegularStyle(fontSize: 13, color: Colors.grey)),
      ),
    );
  }

  Widget _listCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String trailing,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: sfMediumStyle(
                        fontSize: 13, color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(subtitle,
                    style: sfRegularStyle(
                        fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Text(trailing,
              style: sfRegularStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _feeBox(String label, double amount, Color color) {
    return Column(
      children: [
        Text('₹${amount.toStringAsFixed(0)}',
            style: sfMediumStyle(fontSize: 16, color: color)),
        SizedBox(height: 4.h),
        Text(label,
            style: sfRegularStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}