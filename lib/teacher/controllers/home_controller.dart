import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school_management_system/services/api_service.dart';
import 'package:school_management_system/teacher/model/Home/classRoomModel.dart';
import 'package:school_management_system/teacher/view/Adjuncts/TeacherAdjuncts.dart';
import 'package:school_management_system/teacher/view/Chat/chats_page.dart';
import 'package:school_management_system/teacher/view/Home/teacher_home.dart';
import 'package:school_management_system/teacher/view/tasks/TeacherTasksPage.dart';

class TeacherHomeController extends GetxController {
  final _storage = GetStorage();

  // ── Teacher info ──────────────────────────────
  var teacherName = ''.obs;
  var teacherEmail = ''.obs;
  var teacherPhoto = ''.obs;

  // ── Dashboard stats ───────────────────────────
  var totalStudents = 0.obs;
  var todayPresent = 0.obs;
  var activeHomework = 0.obs;

  // ── Lists ─────────────────────────────────────
  var classesList = <ClassRoomModel>[].obs;
  var timetableList = [].obs;
  var noticesList = [].obs;

  // ── Loading states ────────────────────────────
  var isLoadingProfile = false.obs;
  var isLoadingClasses = false.obs;
  var isLoadingTimetable = false.obs;
  var isLoadingNotices = false.obs;

  // ── Bottom nav ────────────────────────────────
  var currentIndex = 0.obs;
  var appBarTitles = ['Home', 'Tasks', 'Adjuncts', 'Chat'].obs;

  List get bottomNavgationBarPages => [
        const HomeTeacher(),
        TeacherTasksPage(),
        TeacherAdjuncts(),
        ChatsPage(),
      ];

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage(); // Pehle storage se load karo (fast)
    fetchTeacherProfile();
    fetchClasses();
    fetchTimetable();
    fetchNotices();
    fetchDashboardStats();
  }

  // Storage se naam turant load karo
  void _loadFromStorage() {
    final userData = _storage.read('user');
    if (userData != null) {
      teacherName.value = userData['name'] ?? '';
      teacherEmail.value = userData['email'] ?? '';
      teacherPhoto.value = userData['photo'] ?? '';
    }
  }

  // ── /api/me ───────────────────────────────────
  Future<void> fetchTeacherProfile() async {
    isLoadingProfile.value = true;
    try {
      final response = await ApiService.dio.get('/me');
      if (response.data['success'] == true) {
        final user = response.data['user'];
        teacherName.value = user['name'] ?? '';
        teacherEmail.value = user['email'] ?? '';
        teacherPhoto.value = user['photo'] ?? '';
      }
    } catch (e) {
      print('fetchTeacherProfile error: $e');
    } finally {
      isLoadingProfile.value = false;
    }
    update();
  }

  // ── /api/classes ──────────────────────────────
  Future<void> fetchClasses() async {
    isLoadingClasses.value = true;
    try {
      final response = await ApiService.dio.get('/classes');
      final List data = response.data is List
          ? response.data
          : (response.data['data'] ?? []);

      classesList.value = data.map((item) => ClassRoomModel(
            classroomID: item['id'].toString(),
            grade: item['name']?.toString() ?? '',
            section: item['section']?.toString() ?? '',
            numberOfstudents: item['students_count'] ?? 0,
          )).toList();

      // Total students count
      int total = 0;
      for (var c in classesList) {
        total += (c.numberOfstudents as int? ?? 0);
      }
      totalStudents.value = total;
    } catch (e) {
      print('fetchClasses error: $e');
    } finally {
      isLoadingClasses.value = false;
    }
    update();
  }

  // ── /api/timetable ────────────────────────────
  Future<void> fetchTimetable() async {
    isLoadingTimetable.value = true;
    try {
      final response = await ApiService.dio.get('/timetable');
      final List data = response.data is List
          ? response.data
          : (response.data['data'] ?? []);
      timetableList.value = data;
    } catch (e) {
      print('fetchTimetable error: $e');
    } finally {
      isLoadingTimetable.value = false;
    }
    update();
  }

  // ── /api/notices ──────────────────────────────
  Future<void> fetchNotices() async {
    isLoadingNotices.value = true;
    try {
      final response = await ApiService.dio.get('/notices');
      final List data = response.data is List
          ? response.data
          : (response.data['data'] ?? []);
      noticesList.value = data;
    } catch (e) {
      print('fetchNotices error: $e');
    } finally {
      isLoadingNotices.value = false;
    }
    update();
  }

  // ── /api/dashboard/stats ──────────────────────
  Future<void> fetchDashboardStats() async {
    try {
      final response = await ApiService.dio.get('/dashboard/stats');
      if (response.data['success'] == true) {
        final data = response.data['data'] ?? response.data;
        todayPresent.value = data['today_present'] ?? 0;
        activeHomework.value = data['active_homework'] ?? 0;
        if (data['total_students'] != null) {
          totalStudents.value = data['total_students'];
        }
      }
    } catch (e) {
      print('fetchDashboardStats error: $e');
    }
    update();
  }

  // ── Nav change ────────────────────────────────
  void changePages(int index) {
    currentIndex.value = index;
    update();
  }
}