import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management_system/public/utils/constant.dart';
import 'package:school_management_system/public/utils/font_style.dart';
import 'package:school_management_system/student/controllers/attendance_controller.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  static const _statusColor = {
    'present': Color(0xFF1D9E75),
    'absent' : Color(0xFFD4537E),
    'late'   : Color(0xFFBA7517),
  };
  static const _statusBg = {
    'present': Color(0xFFE1F5EE),
    'absent' : Color(0xFFFBEAF0),
    'late'   : Color(0xFFFAEEDA),
  };
  static const _statusIcon = {
    'present': Icons.check_circle_rounded,
    'absent' : Icons.cancel_rounded,
    'late'   : Icons.timelapse_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AttendanceController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Attendance',
            style: sfMediumStyle(fontSize: 18, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () => c.getAttendance(),
          ),
        ],
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return Center(
              child: CircularProgressIndicator(color: primaryColor));
        }

        return RefreshIndicator(
          color: primaryColor,
          onRefresh: () => c.getAttendance(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [

                // ── Summary Card ──────────────────
                _buildSummaryCard(c),
                SizedBox(height: 16.h),

                // ── Filter Chips ──────────────────
                _buildFilterChips(c),
                SizedBox(height: 12.h),

                // ── List ──────────────────────────
                c.filtered.isEmpty
                    ? _buildEmpty()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: c.filtered.length,
                        itemBuilder: (_, i) =>
                            _buildAttendanceCard(c.filtered[i]),
                      ),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ── Summary Card ─────────────────────────────────
  Widget _buildSummaryCard(AttendanceController c) {
    return Obx(() => Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, primaryColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Attendance Summary',
                  style: sfRegularStyle(
                      fontSize: 12, color: Colors.white70)),
              SizedBox(height: 6.h),

              // Percentage big text
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${c.percentage.value.toStringAsFixed(1)}%',
                    style: sfMediumStyle(
                        fontSize: 32, color: Colors.white),
                  ),
                  SizedBox(width: 8.w),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Text('attendance',
                        style: sfRegularStyle(
                            fontSize: 12, color: Colors.white70)),
                  ),
                ],
              ),

              SizedBox(height: 6.h),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: c.percentage.value / 100,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    c.percentage.value >= 75
                        ? const Color(0xFF4ADE80)
                        : const Color(0xFFF87171),
                  ),
                  minHeight: 6,
                ),
              ),

              SizedBox(height: 16.h),

              // Stats row
              Row(
                children: [
                  _statBox('Total',   c.total.value.toString(),   Colors.white70),
                  _statBox('Present', c.present.value.toString(), const Color(0xFF4ADE80)),
                  _statBox('Absent',  c.absent.value.toString(),  const Color(0xFFF87171)),
                  _statBox('Late',    c.late.value.toString(),    const Color(0xFFFBBF24)),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _statBox(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: sfMediumStyle(fontSize: 20, color: color)),
          SizedBox(height: 2.h),
          Text(label,
              style: sfRegularStyle(
                  fontSize: 10, color: Colors.white60)),
        ],
      ),
    );
  }

  // ── Filter Chips ─────────────────────────────────
  Widget _buildFilterChips(AttendanceController c) {
    const filters = [
      {'key': 'all',     'label': 'All'},
      {'key': 'present', 'label': 'Present'},
      {'key': 'absent',  'label': 'Absent'},
      {'key': 'late',    'label': 'Late'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Obx(() => Row(
            children: filters.map((f) {
              final isSelected = c.selectedFilter.value == f['key'];
              return GestureDetector(
                onTap: () => c.setFilter(f['key']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? primaryColor
                          : const Color(0xFFE0E0E0),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : [],
                  ),
                  child: Text(
                    f['label']!,
                    style: sfMediumStyle(
                      fontSize: 12,
                      color: isSelected
                          ? Colors.white
                          : Colors.grey[600]!,
                    ),
                  ),
                ),
              );
            }).toList(),
          )),
    );
  }

  // ── Attendance Card ───────────────────────────────
  Widget _buildAttendanceCard(Map record) {
    final status  = record['status']?.toString() ?? 'present';
    final color   = _statusColor[status]  ?? Colors.grey;
    final bg      = _statusBg[status]     ?? Colors.grey[100]!;
    final icon    = _statusIcon[status]   ?? Icons.circle;
    final date    = record['date']?.toString() ?? '';
    final remarks = record['remarks']?.toString() ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Date circle
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_dayNum(date),
                    style: sfMediumStyle(fontSize: 16, color: color)),
                Text(_monthShort(date),
                    style: sfRegularStyle(fontSize: 9, color: color)),
              ],
            ),
          ),
          SizedBox(width: 14.w),

          // Date full + remarks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_formatDate(date),
                    style: sfMediumStyle(
                        fontSize: 13, color: Colors.black87)),
                if (remarks.isNotEmpty) ...[
                  SizedBox(height: 3.h),
                  Text(remarks,
                      style: sfRegularStyle(
                          fontSize: 11, color: Colors.grey)),
                ],
              ],
            ),
          ),

          // Status badge
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 12, color: color),
                SizedBox(width: 4.w),
                Text(
                  _capitalize(status),
                  style: sfMediumStyle(fontSize: 10, color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty ─────────────────────────────────────────
  Widget _buildEmpty() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(30.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: [
          Icon(Icons.event_busy_rounded,
              size: 48, color: Colors.grey[300]),
          SizedBox(height: 12.h),
          Text('Koi attendance record nahi',
              style: sfMediumStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  // ── Date helpers ──────────────────────────────────
  String _dayNum(String d) {
    try { return DateTime.parse(d).day.toString(); } catch (_) { return ''; }
  }

  String _monthShort(String d) {
    const m = ['','Jan','Feb','Mar','Apr','May','Jun',
                'Jul','Aug','Sep','Oct','Nov','Dec'];
    try { return m[DateTime.parse(d).month]; } catch (_) { return ''; }
  }

  String _formatDate(String d) {
    const months = ['','January','February','March','April','May','June',
                    'July','August','September','October','November','December'];
    const days   = ['','Monday','Tuesday','Wednesday',
                    'Thursday','Friday','Saturday','Sunday'];
    try {
      final dt = DateTime.parse(d);
      return '${days[dt.weekday]}, ${dt.day} ${months[dt.month]}';
    } catch (_) { return d; }
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}