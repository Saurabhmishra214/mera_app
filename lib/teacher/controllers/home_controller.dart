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
  var teacherName  = ''.obs;
  var teacherEmail = ''.obs;
  var teacherPhoto = ''.obs;

  // ── Stats ─────────────────────────────────────
  var totalStudents  = 0.obs;
  var activeHomework = 0.obs;
  var totalExams     = 0.obs;
  var totalNotices   = 0.obs;

  // ── Full lists (API se aaye) ──────────────────
  var classesList   = <ClassRoomModel>[].obs;
  var timetableList = [].obs;
  var subjectsList  = [].obs;
  var homeworkList  = [].obs;
  var examsList     = [].obs;
  var noticesList   = [].obs;

  // ── "Show more" flags — 2 dikhao by default ──
  // true = saare dikhao, false = sirf 2
  var showAllClasses   = false.obs;
  var showAllSubjects  = false.obs;
  var showAllHomework  = false.obs;
  var showAllExams     = false.obs;
  var showAllNotices   = false.obs;
  var showAllTimetable = false.obs;

  // Preview count — kitne items pehle dikhane hain
  static const int previewCount = 2;

  // ── Loading ───────────────────────────────────
  var isLoading        = true.obs;
  var isLoadingProfile = false.obs;

  // ── Bottom nav ────────────────────────────────
  var currentIndex = 0.obs;
  var appBarTitles = ['Home', 'Tasks', 'Adjuncts', 'Chat'].obs;

  // Ye getters "show more" logic handle karte hain
  List get visibleClasses   => showAllClasses.value   ? classesList   : classesList.take(previewCount).toList();
  List get visibleSubjects  => showAllSubjects.value  ? subjectsList  : subjectsList.take(previewCount).toList();
  List get visibleHomework  => showAllHomework.value  ? homeworkList  : homeworkList.take(previewCount).toList();
  List get visibleExams     => showAllExams.value     ? examsList     : examsList.take(previewCount).toList();
  List get visibleNotices   => showAllNotices.value   ? noticesList   : noticesList.take(previewCount).toList();
  List get visibleTimetable => showAllTimetable.value ? timetableList : timetableList.take(previewCount).toList();

  List get bottomNavgationBarPages => [
        const HomeTeacher(),
        TeacherTasksPage(),
        TeacherAdjuncts(),
        ChatsPage(),
      ];

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
    fetchTeacherProfile();
    fetchDashboard(); // ← ek hi API call sab kuch
  }

  void _loadFromStorage() {
    final userData = _storage.read('user');
    if (userData != null) {
      teacherName.value  = userData['name']  ?? '';
      teacherEmail.value = userData['email'] ?? '';
      teacherPhoto.value = userData['photo'] ?? '';
    }
  }

  // ── /api/me ───────────────────────────────────
  Future<void> fetchTeacherProfile() async {
    isLoadingProfile.value = true;
    try {
      final res = await ApiService.dio.get('/me');
      if (res.data is Map && res.data['success'] == true) {
        final user = res.data['user'] ?? res.data['data'] ?? {};
        teacherName.value  = user['name']  ?? '';
        teacherEmail.value = user['email'] ?? '';
        teacherPhoto.value = user['photo'] ?? '';
        // Storage mein bhi save karo
        _storage.write('user', user);
      }
    } catch (e) {
      print('🔴 [/me] $e');
    } finally {
      isLoadingProfile.value = false;
    }
    update();
  }

  // ── /api/teacher/dashboard — ek call, sab data ─
  Future<void> fetchDashboard() async {
    isLoading.value = true;
    try {
      final res = await ApiService.dio.get('/teacher/dashboard');
      print('🔵 [/teacher/dashboard] ${res.statusCode}');

      if (res.data is Map && res.data['success'] == true) {
        final d = res.data['data'] as Map;

        // ── Stats ─────────────────────────────
        final stats = d['stats'] ?? {};
        totalStudents.value  = stats['total_students']  ?? 0;
        activeHomework.value = stats['active_homework'] ?? 0;
        totalExams.value     = stats['upcoming_exams']  ?? 0;
        totalNotices.value   = stats['total_notices']   ?? 0;

        // ── Classes ───────────────────────────
        final rawClasses = d['classes'] as List? ?? [];
        classesList.value = rawClasses.map((item) => ClassRoomModel(
              classroomID:      (item['id'] ?? '').toString(),
              grade:            (item['name'] ?? '').toString(),
              section:          (item['section'] ?? '').toString(),
              numberOfstudents: item['students_count'] ?? 0,
            )).toList();

        // ── Timetable ─────────────────────────
        timetableList.value = d['timetable'] as List? ?? [];

        // ── Subjects ──────────────────────────
        subjectsList.value = d['subjects'] as List? ?? [];

        // ── Homework ──────────────────────────
        homeworkList.value = d['homework'] as List? ?? [];

        // ── Exams ─────────────────────────────
        examsList.value = d['exams'] as List? ?? [];

        // ── Notices ───────────────────────────
        noticesList.value = d['notices'] as List? ?? [];

        print('✅ classes:${classesList.length} hw:${homeworkList.length} exams:${examsList.length} notices:${noticesList.length}');
      }
    } catch (e) {
      print('🔴 [/teacher/dashboard] $e');
    } finally {
      isLoading.value = false;
    }
    update();
  }

  // ── Nav change ────────────────────────────────
  void changePages(int index) {
    currentIndex.value = index;
    update();
  }
}