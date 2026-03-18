import 'package:get/get.dart';
import 'package:school_management_system/services/api_service.dart';

class StudentSubjectController extends GetxController {
  // ─── Subjects List ────────────────────────────────
  var isLoading     = false.obs;
  var subjects      = [].obs;
  var className     = ''.obs;

  // ─── Subject Detail ───────────────────────────────
  var isDetailLoading = false.obs;
  var subjectName     = ''.obs;
  var homework        = [].obs;
  var timetable       = [].obs;

  // ─── Subjects fetch karo ─────────────────────────
  Future<void> getMySubjects() async {
    try {
      isLoading.value = true;
      final data = await ApiService.get('/student/subjects');

      if (data['success'] == true) {
        subjects.value  = data['subjects'] ?? [];
        className.value = data['class']    ?? '';
      } else {
        subjects.value = [];
      }
    } catch (e) {
      print('Subjects error: $e');
      subjects.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Homework fetch karo ──────────────────────────
  Future<void> getHomework(String subjectId) async {
    try {
      isDetailLoading.value = true;
      homework.value        = [];

      final data =
          await ApiService.get('/student/subjects/$subjectId/homework');

      if (data['success'] == true) {
        subjectName.value = data['subject_name'] ?? '';
        homework.value    = data['homework']     ?? [];
      }
    } catch (e) {
      print('Homework error: $e');
    } finally {
      isDetailLoading.value = false;
    }
  }

  // ─── Timetable fetch karo ─────────────────────────
  Future<void> getTimetable(String subjectId) async {
    try {
      isDetailLoading.value = true;
      timetable.value       = [];

      final data =
          await ApiService.get('/student/subjects/$subjectId/timetable');

      if (data['success'] == true) {
        subjectName.value = data['subject_name'] ?? '';
        timetable.value   = data['timetable']    ?? [];
      }
    } catch (e) {
      print('Timetable error: $e');
    } finally {
      isDetailLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getMySubjects();
  }
}