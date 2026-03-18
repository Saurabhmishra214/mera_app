import 'package:get/get.dart';
import 'package:school_management_system/services/api_service.dart';

class AttendanceController extends GetxController {
  // ── State ─────────────────────────────────────────
  var isLoading = true.obs;

  // Attendance records list
  var attendance = [].obs;

  // Summary
  var total      = 0.obs;
  var present    = 0.obs;
  var absent     = 0.obs;
  var late       = 0.obs;
  var percentage = 0.0.obs;

  // Filter: 'all' | 'present' | 'absent' | 'late'
  var selectedFilter = 'all'.obs;

  // Filtered list (computed)
  List get filtered {
    if (selectedFilter.value == 'all') return attendance;
    return attendance
        .where((a) => a['status'] == selectedFilter.value)
        .toList();
  }

  // ── API ───────────────────────────────────────────
  Future<void> getAttendance() async {
    try {
      isLoading.value = true;
      final data = await ApiService.get('/student/attendance');

      attendance.value = data['attendance'] ?? [];

      final s      = data['summary'] ?? {};
      total.value      = int.parse((s['total']   ?? 0).toString());
      present.value    = int.parse((s['present'] ?? 0).toString());
      absent.value     = int.parse((s['absent']  ?? 0).toString());
      late.value       = int.parse((s['late']    ?? 0).toString());
      percentage.value = double.parse((s['percentage'] ?? 0).toString());

    } catch (e) {
      print('AttendanceController error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setFilter(String filter) => selectedFilter.value = filter;

  @override
  void onInit() {
    super.onInit();
    getAttendance();
  }
}