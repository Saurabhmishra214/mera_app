import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management_system/public/utils/constant.dart';
import 'package:school_management_system/public/utils/font_style.dart';
import 'package:school_management_system/student/controllers/result_controller.dart';

// ── Grade color helper ─────────────────────────────────
Color _gradeColor(String grade) {
  switch (grade) {
    case 'A+': return const Color(0xFF1D9E75);
    case 'A':  return const Color(0xFF378ADD);
    case 'B':  return const Color(0xFF5B4FCF);
    case 'C':  return const Color(0xFFBA7517);
    case 'D':  return const Color(0xFFD4537E);
    default:   return const Color(0xFFE24B4A);
  }
}

Color _gradeBgColor(String grade) {
  switch (grade) {
    case 'A+': return const Color(0xFFE1F5EE);
    case 'A':  return const Color(0xFFE6F1FB);
    case 'B':  return const Color(0xFFEEEDFE);
    case 'C':  return const Color(0xFFFAEEDA);
    case 'D':  return const Color(0xFFFBEAF0);
    default:   return const Color(0xFFFCEBEB);
  }
}

// ══════════════════════════════════════════════════════
// SCREEN 1 — Exams List
// ══════════════════════════════════════════════════════
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ResultController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF378ADD),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('My Results',
            style: sfMediumStyle(fontSize: 18, color: Colors.white)),
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(
                  color: Color(0xFF378ADD)));
        }

        if (c.exams.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bar_chart_outlined,
                    size: 56, color: Colors.grey[300]),
                SizedBox(height: 12.h),
                Text('Koi result nahi mila',
                    style: sfMediumStyle(
                        fontSize: 15, color: Colors.grey)),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () => c.getMyExams(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF378ADD),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Retry',
                      style: sfRegularStyle(
                          fontSize: 13, color: Colors.white)),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: c.exams.length,
          itemBuilder: (_, i) {
            final exam = c.exams[i];
            return _ExamCard(exam: exam);
          },
        );
      }),
    );
  }
}

// ── Exam Card ─────────────────────────────────────────
class _ExamCard extends StatelessWidget {
  final Map exam;
  const _ExamCard({required this.exam});

  Color get _typeColor {
    switch ((exam['type'] ?? '').toString().toLowerCase()) {
      case 'unit_test': return const Color(0xFF5B4FCF);
      case 'mid_term':  return const Color(0xFFBA7517);
      case 'final':     return const Color(0xFFE24B4A);
      default:          return const Color(0xFF378ADD);
    }
  }

  String get _typeLabel {
    switch ((exam['type'] ?? '').toString().toLowerCase()) {
      case 'unit_test': return 'Unit Test';
      case 'mid_term':  return 'Mid Term';
      case 'final':     return 'Final Exam';
      default:          return exam['type'] ?? 'Exam';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => ExamResultDetailScreen(
          examId:   exam['id'].toString(),
          examName: exam['name'] ?? '',
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: _typeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.description_outlined,
                  color: _typeColor, size: 24),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exam['name'] ?? '',
                      style: sfMediumStyle(
                          fontSize: 14, color: Colors.black87)),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: _typeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(_typeLabel,
                            style: sfRegularStyle(
                                fontSize: 9, color: _typeColor)),
                      ),
                      SizedBox(width: 8.w),
                      Icon(Icons.book_outlined,
                          size: 11, color: Colors.grey),
                      SizedBox(width: 3.w),
                      Text(
                        '${exam['total_subjects'] ?? 0} subjects',
                        style: sfRegularStyle(
                            fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 11, color: Colors.grey),
                      SizedBox(width: 3.w),
                      Text(exam['exam_date'] ?? '',
                          style: sfRegularStyle(
                              fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// SCREEN 2 — Exam Result Detail
// ══════════════════════════════════════════════════════
class ExamResultDetailScreen extends StatelessWidget {
  final String examId;
  final String examName;

  const ExamResultDetailScreen({
    Key? key,
    required this.examId,
    required this.examName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ResultController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF378ADD),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(examName,
            style: sfMediumStyle(fontSize: 18, color: Colors.white)),
      ),
      body: FutureBuilder(
        future: c.getExamResults(examId),
        builder: (context, snapshot) {
          return Obx(() {
            if (c.isDetailLoading.value) {
              return const Center(
                  child: CircularProgressIndicator(
                      color: Color(0xFF378ADD)));
            }

            if (c.results.isEmpty) {
              return Center(
                child: Text('Koi result nahi',
                    style: sfRegularStyle(
                        fontSize: 14, color: Colors.grey)),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SummaryCard(controller: c),
                  SizedBox(height: 20.h),
                  Text('Subject-wise Marks',
                      style: sfMediumStyle(
                          fontSize: 15, color: Colors.black87)),
                  SizedBox(height: 10.h),
                  // ✅ Map ko List mein convert karo
                  ...c.results.map((r) =>
                      _ResultCard(result: Map<String, dynamic>.from(r))),
                ],
              ),
            );
          });
        },
      ),
    );
  }
}

// ── Summary Card ──────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final ResultController controller;
  const _SummaryCard({required this.controller});

  Color get _percentageColor {
    final p = controller.percentage.value;
    if (p >= 80) return const Color(0xFF1D9E75);
    if (p >= 60) return const Color(0xFF378ADD);
    if (p >= 40) return const Color(0xFFBA7517);
    return const Color(0xFFE24B4A);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _percentageColor.withOpacity(0.1),
              border: Border.all(color: _percentageColor, width: 3),
            ),
            child: Center(
              child: Text(
                '${controller.percentage.value.toStringAsFixed(1)}%',
                style: sfMediumStyle(
                    fontSize: 13, color: _percentageColor),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(controller.examName.value,
                    style: sfMediumStyle(
                        fontSize: 14, color: Colors.black87)),
                SizedBox(height: 8.h),
                _statRow('Total Marks',
                    '${controller.totalMarks.value}'),
                SizedBox(height: 4.h),
                _statRow('Obtained',
                    '${controller.obtainedMarks.value}',
                    color: _percentageColor),
                SizedBox(height: 4.h),
                _statRow(
                  'Status',
                  controller.percentage.value >= 33 ? 'Pass' : 'Fail',
                  color: controller.percentage.value >= 33
                      ? const Color(0xFF1D9E75)
                      : const Color(0xFFE24B4A),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value, {Color? color}) {
    return Row(
      children: [
        Text('$label: ',
            style: sfRegularStyle(fontSize: 11, color: Colors.grey)),
        Text(value,
            style: sfMediumStyle(
                fontSize: 11, color: color ?? Colors.black87)),
      ],
    );
  }
}

// ── Result Card ───────────────────────────────────────
class _ResultCard extends StatelessWidget {
  final Map<String, dynamic> result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final grade = result['grade']?.toString() ?? 'F';
    final status = result['status']?.toString() ?? 'Fail';
    final isPass = status == 'Pass';

    // ✅ Safe number parsing — crash fix
    final marks = num.tryParse(
            result['marks']?.toString() ?? '0') ?? 0;
    final fullMarks = num.tryParse(
            result['full_marks']?.toString() ?? '0') ?? 0;
    final progress = fullMarks > 0
        ? (marks.toDouble() / fullMarks.toDouble()).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  result['subject_name']?.toString() ?? '',
                  style: sfMediumStyle(
                      fontSize: 13, color: Colors.black87),
                ),
              ),
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: _gradeBgColor(grade),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(grade,
                      style: sfMediumStyle(
                          fontSize: 12,
                          color: _gradeColor(grade))),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // ✅ Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFE8E8E8),
              color: _gradeColor(grade),
              minHeight: 6,
            ),
          ),
          SizedBox(height: 8.h),

          Row(
            children: [
              Text('$marks / $fullMarks marks',
                  style: sfRegularStyle(
                      fontSize: 11, color: Colors.grey)),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: isPass
                      ? const Color(0xFFE1F5EE)
                      : const Color(0xFFFCEBEB),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  status,
                  style: sfRegularStyle(
                    fontSize: 9,
                    color: isPass
                        ? const Color(0xFF085041)
                        : const Color(0xFFA32D2D),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}