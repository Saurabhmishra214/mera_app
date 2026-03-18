import 'package:school_management_system/services/api_service.dart';
import '../../models/task/task_model.dart';

class taskServices {

  Future<List<TaskModel>> getTasks() async {
    try {
      final data = await ApiService.get('/homework');

      List list = [];
      if (data['data'] != null && data['data']['data'] != null) {
        list = data['data']['data']; // paginated
      } else if (data['data'] != null) {
        list = List.from(data['data']);
      }

      return list.map((item) => TaskModel(
        id:          item['id'].toString(),
        name:        item['title']               ?? '',
        subjectName: item['subject'] != null
                       ? item['subject']['name'] ?? ''
                       : '',
        uploadDate:  item['created_at'] != null
                       ? item['created_at'].toString().substring(0, 10)
                       : '',
        deadline:    item['due_date'] != null
                       ? item['due_date'].toString().substring(0, 10)
                       : '',
        url:         item['attachment_url']      ?? '',
      )).toList();

    } catch (e) {
      print('getTasks error: $e');
      return [];
    }
  }

  Future<void> uploadTaskResult({
    required String homeworkId,
    required String fileUrl,
  }) async {
    try {
      await ApiService.post('/homework/$homeworkId/submit', {
        'file_url': fileUrl,
      });
    } catch (e) {
      print('uploadTaskResult error: $e');
    }
  }
}