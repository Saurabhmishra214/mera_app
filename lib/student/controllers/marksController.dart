import 'package:get/get.dart';
import 'package:school_management_system/services/api_service.dart';

class MarksModel {
  final String title;
  final dynamic mark;
  final dynamic fmark;

  MarksModel({
    this.title = '',
    this.mark  = '-',
    this.fmark = '-',
  });
}

class MarksController extends GetxController {

  var isLoading  = true.obs;
  var resultList = [].obs;
  var subjectId  = ''.obs;

  // Individual marks
  var exam1     = MarksModel().obs;
  var tests     = MarksModel().obs;
  var homeworks = MarksModel().obs;
  var exam2     = MarksModel().obs;

  // ─── API se results lo ────────────────────────
  Future<void> getResults(String sId) async {
    try {
      isLoading.value = true;
      final data = await ApiService.get('/results?subject_id=$sId');

      List list = [];
      if (data['data'] != null && data['data']['data'] != null) {
        list = data['data']['data'];
      } else if (data['data'] != null) {
        list = List.from(data['data']);
      }

      resultList.value = list;

      // Results parse karo
      for (var item in list) {
        final examType = item['exam']?['type'] ?? '';
        final obtained = item['marks_obtained'] ?? '-';
        final total    = item['exam']?['full_marks'] ?? '-';
        final name     = item['exam']?['name'] ?? examType;

        switch (examType) {
          case 'mid_term':
            exam1.value = MarksModel(
              title: name, mark: obtained, fmark: total);
            break;
          case 'final':
            exam2.value = MarksModel(
              title: name, mark: obtained, fmark: total);
            break;
          case 'test':
            tests.value = MarksModel(
              title: name, mark: obtained, fmark: total);
            break;
          default:
            break;
        }
      }

    } catch (e) {
      print('Results error: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Yeh methods purani compatibility ke liye
  Future<void> getExam1(String sId) async => await getResults(sId);
  Future<void> getTests(String sId)  async => await getResults(sId);
  Future<void> getHomeworks(String sId) async {}
  Future<void> getExam2(String sId)  async {}
}