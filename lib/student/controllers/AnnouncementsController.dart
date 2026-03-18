import 'package:get/get.dart';
import 'package:school_management_system/services/api_service.dart';

class AnnouncementsController extends GetxController {

  var isLoading         = true.obs;
  var announcementsList = [].obs;

  Future<void> getAnnouncements() async {
    try {
      isLoading.value = true;
      final data = await ApiService.get('/notices');

      // ✅ Fix — 'data' key use karo, 'notices' nahi
      // Response: {'success': true, 'data': {'data': [...pagination...]}}
      if (data['data'] != null) {
        final pageData = data['data'];
        if (pageData['data'] != null) {
          // Paginated response
          announcementsList.value = List.from(pageData['data']);
        } else {
          announcementsList.value = List.from(pageData);
        }
      } else {
        announcementsList.value = [];
      }

    } catch (e) {
      print('Announcements error: $e');
      announcementsList.value = [];
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getAnnouncements();
  }
}