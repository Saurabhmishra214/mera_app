import 'package:get/get.dart';
import 'package:school_management_system/services/api_service.dart';

class TimetableController extends GetxController {
  // ── State ─────────────────────────────────────────
  var isLoading = true.obs;
  var className = ''.obs;

  // { 'Monday': [...], 'Tuesday': [...], ... }
  var timetable = <String, List>{}.obs;

  // Days list
  final days = [
    'Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday',
  ];

  // Selected day
  var selectedDay = 'Monday'.obs;

  // Aaj ke slots
  List get todaySlots => timetable[selectedDay.value] ?? [];

  // ── API ───────────────────────────────────────────
  Future<void> getTimetable() async {
    try {
      isLoading.value = true;
      final data = await ApiService.get('/student/timetable');

      className.value = data['class'] ?? '';

      final raw = data['timetable'] as Map<String, dynamic>? ?? {};

      // ⚠️ FIX: API lowercase keys return karta hai ("monday")
      // Controller uppercase expect karta hai ("Monday")
      // Solution: keys ko capitalize karo
      final normalized = <String, List>{};
      raw.forEach((key, value) {
        // "monday" → "Monday"
        final capitalizedKey = key[0].toUpperCase() + key.substring(1);
        normalized[capitalizedKey] = List.from(value);
      });

      timetable.value = normalized;

    } catch (e) {
      print('TimetableController error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Day select ────────────────────────────────────
  void selectDay(String day) => selectedDay.value = day;

  @override
  void onInit() {
    super.onInit();
    // Aaj ka din default select karo
    final today = DateTime.now().weekday; // 1=Mon...6=Sat
    if (today >= 1 && today <= 6) {
      selectedDay.value = days[today - 1];
    }
    getTimetable();
  }
}