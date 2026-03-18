import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school_management_system/services/api_service.dart';

class MoreController extends GetxController {
  // ── Student Info (GetStorage se) ──────────────────
  var studentName  = ''.obs;
  var studentClass = ''.obs;
  var studentRoll  = ''.obs;

  // ── Logout loading ────────────────────────────────
  var isLoggingOut = false.obs;

  // ── Load student info from local storage ──────────
  void loadStudentInfo() {
    final box  = GetStorage();
    final user = box.read('user');

    if (user != null) {
      studentName.value  = user['name']  ?? '';
      studentClass.value = user['class'] ?? '';
      studentRoll.value  = user['roll']  ?? '';
    }
  }

  // ── Logout ────────────────────────────────────────
  Future<void> logout() async {
    try {
      isLoggingOut.value = true;

      // Server pe token invalidate karo
      try {
        await ApiService.post('/logout', {});
      } catch (_) {
        // Server error ignore karo — local logout zaroor karo
      }

      // Local storage clear
      final box = GetStorage();
      box.erase();

      // Login screen pe bhejo (sab screens hata ke)
      Get.offAllNamed('/login');

    } catch (e) {
      print('Logout error: $e');
      Get.snackbar(
        'Error',
        'Logout nahi ho paya. Dobara try karo.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoggingOut.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadStudentInfo();
  }
}