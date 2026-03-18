import 'package:get/get.dart';
import 'package:school_management_system/services/api_service.dart';

class ResultController extends GetxController {
  // ─── Exams List ───────────────────────────────────
  var isLoading  = false.obs;
  var exams      = [].obs;

  // ─── Exam Detail ──────────────────────────────────
  var isDetailLoading = false.obs;
  var examName        = ''.obs;
  var examDate        = ''.obs;
  var results         = [].obs;
  var percentage      = 0.0.obs;
  var totalMarks      = 0.obs;
  var obtainedMarks   = 0.obs;

  // ─── Exams fetch ──────────────────────────────────
  Future<void> getMyExams() async {
    try {
      isLoading.value = true;
      final data = await ApiService.get('/student/exams');
      if (data['success'] == true) {
        exams.value = data['exams'] ?? [];
      }
    } catch (e) {
      print('Exams error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Exam results fetch ───────────────────────────
  Future<void> getExamResults(String examId) async {
    try {
      isDetailLoading.value = true;
      results.value         = [];

      final data = await ApiService.get('/student/exams/$examId/results');

      if (data['success'] == true) {
        examName.value = data['exam_name'] ?? '';
        examDate.value = data['exam_date'] ?? '';

        // ✅ Safe number parsing — String bhi aaye toh crash nahi hoga
        percentage.value = num.tryParse(
                data['overall_percentage']?.toString() ?? '0')
            ?.toDouble() ?? 0.0;

        totalMarks.value = num.tryParse(
                data['total_marks']?.toString() ?? '0')
            ?.toInt() ?? 0;

        obtainedMarks.value = num.tryParse(
                data['obtained_marks']?.toString() ?? '0')
            ?.toInt() ?? 0;

        results.value = data['results'] ?? [];
      }
    } catch (e) {
      print('Exam results error: $e');
    } finally {
      isDetailLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getMyExams();
  }
}