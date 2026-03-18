import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school_management_system/services/api_service.dart';
import 'package:school_management_system/student/view/Home/home_body.dart';
import 'package:school_management_system/student/view/Subjects/SubjectsScreen.dart';
import 'package:school_management_system/student/view/Results/results_screen.dart';
import 'package:school_management_system/student/view/Fees/fees_screen.dart';
import 'package:school_management_system/student/view/More/more_screen.dart';

import '../../main.dart';


class HomeController extends GetxController {

  // ─── Navigation ───────────────────────────────
  var currentIndex = 0.obs;
  var appBarTitles = ['Home', 'Subjects', 'Results', 'Fees', 'More'].obs;
  var bottomNavgationBarPages = <Widget>[
    HomeScreen(),
    SubjectsScreen(),
    ResultsScreen(),
    FeesScreen(),
    MoreScreen(),
  ].obs;

  // ─── Dashboard Data ───────────────────────────
  var isLoading    = true.obs;
  var studentName  = ''.obs;
  var studentClass = ''.obs;
  var subjects     = [].obs;
  var homework     = [].obs;
  var exams        = [].obs;
  var notices      = [].obs;
  var feeTotal     = 0.0.obs;
  var feePaid      = 0.0.obs;
  var feePending   = 0.0.obs;

  // ─── Side Menu ke liye ────────────────────────
  var mychilds   = [].obs;
  var myprograms = [].obs;

  // ─── ZoomDrawer ───────────────────────────────
  final zoomDrawerController = ZoomDrawerController();

  // ─── Dashboard API ────────────────────────────
// ─── Dashboard API ────────────────────────────
  Future<void> getDashboard() async {
    try {
      isLoading.value = true;
      final data = await ApiService.get('/student/dashboard');

      if (data['student'] != null) {
        studentName.value = data['student']['name'] ?? '';

        // ⚠️ FIX: section blank hai is school mein (no sections)
        // Pehle '${class} - ${section}' tha jo "Class 6 - " bana raha tha
        final className   = data['student']['class']   ?? '';
        final sectionName = data['student']['section'] ?? '';
        studentClass.value = sectionName.isNotEmpty
            ? '$className - $sectionName'
            : className;

        final box = GetStorage();
        box.write('user', {
          'name':  data['student']['name'],
          'class': studentClass.value,
        });
      }

      // ✅ Subjects — ab dashboard se directly aayenge
      subjects.value = List<Map<String, dynamic>>.from(
        (data['subjects'] as List? ?? []).map((s) => Map<String, dynamic>.from(s))
      );

      homework.value = data['homework'] ?? [];
      exams.value    = data['exams']    ?? [];
      notices.value  = data['notices']  ?? [];

      if (data['fees'] != null) {
        feeTotal.value   = double.parse(data['fees']['total'].toString());
        feePaid.value    = double.parse(data['fees']['paid'].toString());
        feePending.value = double.parse(data['fees']['pending'].toString());
      }

    } catch (e) {
      print('Dashboard error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Side Menu ────────────────────────────────
  Future<void> getchilds() async {
    mychilds.value = [];
    update();
  }

  Future<void> getPrograms() async {
    myprograms.value = [];
    update();
  }

  // ─── Navigation ───────────────────────────────
  void changePages(int index) {
    currentIndex.value = index;
    update();
  }

  // ─── Notifications ────────────────────────────
  void showNotification(String filename, String path) {
    flutterLocalNotificationsPlugin.show(
      0, filename, "Downloaded: $path",
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id, channel.name,
          importance: Importance.high,
          color: Colors.blue,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  void showNotification2(String filename, String path) {
    showNotification(filename, path);
  }

  // ─── onInit ───────────────────────────────────
  @override
  void onInit() {
    super.onInit();

    final box = GetStorage();
    final userData = box.read('user');
    if (userData != null) {
      studentName.value  = userData['name']  ?? '';
      studentClass.value = userData['class'] ?? '';
    }

    getDashboard();
  }
}