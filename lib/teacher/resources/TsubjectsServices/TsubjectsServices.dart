import 'package:school_management_system/services/api_service.dart';
import 'package:school_management_system/teacher/Teacher_global_info/Subjects_of_teacher/TeacherSubjects.dart';
import 'package:school_management_system/teacher/model/subject/TeacherSubjectModel.dart';

class TSubjetcsServices {
  getTeacherSubjectForClass(String grade, String classId) async {
    var subjectList = [];

    try {
      final response = await ApiService.dio.get(
        '/subjects',
        queryParameters: {
          'grade': grade,
          'class_id': classId,
        },
      );

      var data = response.data is List
          ? response.data
          : response.data['data'] ?? [];

      for (var item in data) {
        var subject = TeacherSubjectModel(
          subjectName: item['name']?.toString() ?? '',
          subjectId: item['id']?.toString() ?? '',
          grade: item['grade']?.toString() ?? grade,
        );
        subjectList.add(subject);
        TeacherSubjects.subjectsList.add(subject);
      }

      return subjectList;
    } catch (e) {
      print('getTeacherSubjectForClass error: $e');
      return [];
    }
  }

  static getAllTeacherSubject() async {
    var subjectList = [];
    TeacherSubjects.subjectsList.clear();

    try {
      final response = await ApiService.dio.get('/subjects');

      var data = response.data is List
          ? response.data
          : response.data['data'] ?? [];

      for (var item in data) {
        var subject = TeacherSubjectModel(
          subjectName: item['name']?.toString() ?? '',
          subjectId: item['id']?.toString() ?? '',
          grade: item['grade']?.toString() ?? '',
        );
        subjectList.add(subject);
        TeacherSubjects.subjectsList.add(subject);
      }

      return subjectList;
    } catch (e) {
      print('getAllTeacherSubject error: $e');
      return [];
    }
  }
}