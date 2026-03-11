import 'package:school_management_system/services/api_service.dart';
import 'package:school_management_system/teacher/Teacher_global_info/Classes_of_Teacher/TeacherClasses.dart';
import 'package:school_management_system/teacher/model/Home/classRoomModel.dart';

class TClassesServices {
  getTeacherClasses() async {
    var classesList = [];
    TeacherClasses.classesList.clear();

    try {
      final response = await ApiService.dio.get('/classes');

      if (response.data is List) {
        for (var item in response.data) {
          var classroom = ClassRoomModel(
            classroomID: item['id'].toString(),
            grade: item['grade']?.toString() ?? '',
            section: item['section']?.toString() ?? '',
            numberOfstudents: item['students_count'] ?? item['number_of_students'] ?? 0,
          );
          classesList.add(classroom);
          TeacherClasses.classesList.add(classroom);
        }
      } else if (response.data['data'] != null) {
        for (var item in response.data['data']) {
          var classroom = ClassRoomModel(
            classroomID: item['id'].toString(),
            grade: item['grade']?.toString() ?? '',
            section: item['section']?.toString() ?? '',
            numberOfstudents: item['students_count'] ?? item['number_of_students'] ?? 0,
          );
          classesList.add(classroom);
          TeacherClasses.classesList.add(classroom);
        }
      }

      return classesList;
    } catch (e) {
      print('TClassesServices error: $e');
      return classesList;
    }
  }
}