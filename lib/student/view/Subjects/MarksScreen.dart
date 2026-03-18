import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management_system/public/utils/constant.dart';
import 'package:school_management_system/public/utils/font_families.dart';
import 'package:school_management_system/public/utils/font_style.dart';
import 'package:school_management_system/student/controllers/marksController.dart';

class MarksList extends StatelessWidget {
  const MarksList({Key? key, this.subjectId}) : super(key: key);
  final subjectId;

  @override
  Widget build(BuildContext context) {
    final MarksController c = Get.put(MarksController());

    // Subject ke results lo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (subjectId != null) {
        c.getResults(subjectId.toString());
      }
    });

    return Obx(() {

      // Loading
      if (c.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // Empty
      if (c.resultList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart,
                  size: 64, color: Colors.grey.shade300),
              SizedBox(height: 16.h),
              Text('No results yet',
                  style: sfRegularStyle(
                      fontSize: 16, color: Colors.grey)),
            ],
          ),
        );
      }

      // Results list
      return ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: c.resultList.length,
        itemBuilder: (context, index) {
          final item    = c.resultList[index];
          final exam    = item['exam']           ?? {};
          final title   = exam['name']           ?? '';
          final type    = exam['type']           ?? '';
          final obtained = item['marks_obtained'] ?? 0;
          final total   = exam['full_marks']     ?? 0;
          final grade   = item['grade']          ?? '';

          // Pass/Fail check
          final passMarks = exam['pass_marks'] ?? 0;
          final isPassed  = obtained >= passMarks;

          return _ResultCard(
            title:    title,
            type:     type,
            obtained: obtained,
            total:    total,
            grade:    grade,
            isPassed: isPassed,
          );
        },
      );
    });
  }
}

// ── Result Card ───────────────────────────────
class _ResultCard extends StatelessWidget {
  final String title;
  final String type;
  final dynamic obtained;
  final dynamic total;
  final String grade;
  final bool isPassed;

  const _ResultCard({
    required this.title,
    required this.type,
    required this.obtained,
    required this.total,
    required this.grade,
    required this.isPassed,
  });

  Color get _typeColor {
    switch (type) {
      case 'mid_term': return Colors.orange;
      case 'final':    return Colors.red;
      case 'test':     return Colors.blue;
      default:         return primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0
        ? ((obtained / total) * 100).toStringAsFixed(1)
        : '0';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          left: BorderSide(color: _typeColor, width: 4),
        ),
      ),
      child: Row(
        children: [

          // ── Left: Title & Type ─────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: redHatMediumStyle(
                        fontSize: 15, color: Colors.black87)),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: _typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    type.replaceAll('_', ' ').toUpperCase(),
                    style: sfRegularStyle(
                        fontSize: 10, color: _typeColor),
                  ),
                ),
              ],
            ),
          ),

          // ── Right: Marks & Grade ───────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Marks
              Row(
                children: [
                  Text('$obtained',
                      style: redHatMediumStyle(
                          fontSize: 22,
                          color: isPassed ? Colors.green : Colors.red)),
                  Text('/$total',
                      style: sfRegularStyle(
                          fontSize: 14, color: Colors.grey)),
                ],
              ),
              SizedBox(height: 4.h),
              // Percentage
              Text('$percentage%',
                  style: sfRegularStyle(
                      fontSize: 12, color: Colors.grey)),
              SizedBox(height: 4.h),
              // Grade badge
              if (grade.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: isPassed
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Grade: $grade',
                    style: sfRegularStyle(
                        fontSize: 11,
                        color: isPassed ? Colors.green : Colors.red),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Shimmer Loading ───────────────────────────
class ShimmerMarksLoading extends StatelessWidget {
  const ShimmerMarksLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}