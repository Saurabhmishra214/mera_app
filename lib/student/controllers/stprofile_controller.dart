import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:school_management_system/services/api_service.dart';
import 'package:school_management_system/public/config/user_information.dart';

class StprofileController extends GetxController {

  // ─── Profile Data ─────────────────────────────
  var isLoading   = true.obs;
  var isShow      = false.obs;
  var studentMarks = [].obs;

  var name        = ''.obs;
  var email       = ''.obs;
  var phone       = ''.obs;
  var parentPhone = ''.obs;
  var className   = ''.obs;
  var rollNumber  = ''.obs;
  var gender      = ''.obs;
  var address     = ''.obs;
  var photoUrl    = ''.obs;

  var feePaid     = 0.0.obs;
  var feePending  = 0.0.obs;
  var feeTotal    = 0.0.obs;

  // Image picker
  Rx<Uint8List> image = Uint8List(0).obs;

  @override
  void onInit() {
    super.onInit();
    // Storage se turant dikhao
    _loadFromStorage();
    // API se fresh data lo
    getProfileData();
  }

  // ─── Storage se load karo ─────────────────────
  void _loadFromStorage() {
    final box = GetStorage();
    final userData = box.read('user');
    if (userData != null) {
      name.value      = userData['name']      ?? '';
      email.value     = userData['email']     ?? '';
      className.value = userData['class']     ?? '';
      photoUrl.value  = userData['photo']     ?? '';
    }
  }

  // ─── API se profile lo ────────────────────────
  Future<void> getProfileData() async {
    try {
      isLoading.value = true;

      // /me endpoint se user data lo
      final response = await ApiService.get('/me');

      if (response['user'] != null) {
        final user    = response['user'];
        final student = response['student'];

        name.value        = user['name']               ?? '';
        email.value       = user['email']              ?? '';
        phone.value       = student?['phone']          ?? '';
        parentPhone.value = student?['parent_phone']   ?? '';
        rollNumber.value  = student?['roll_number']    ?? '';
        gender.value      = student?['gender']         ?? '';
        address.value     = student?['address']        ?? '';
        photoUrl.value    = student?['photo']          ?? '';

        if (student?['school_class'] != null) {
          className.value =
            '${student['school_class']['name']} - ${student['school_class']['section']}';
        }

        // Fee data
        if (response['fees'] != null) {
          feeTotal.value   = double.parse(response['fees']['total'].toString());
          feePaid.value    = double.parse(response['fees']['paid'].toString());
          feePending.value = double.parse(response['fees']['pending'].toString());
        }

        // Storage update karo
        final box = GetStorage();
        box.write('user', {
          'name':  user['name'],
          'email': user['email'],
          'class': className.value,
          'photo': photoUrl.value,
        });

        // UserInformation bhi update karo
        UserInformation.fullname  = user['name']    ?? '';
        UserInformation.email     = user['email']   ?? '';
        UserInformation.clasname  = className.value;
        UserInformation.urlAvatr  = photoUrl.value  ?? '';
        UserInformation.phone     = student?['phone'] ?? '';
      }

    } catch (e) {
      print('Profile error: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // ─── Marks ────────────────────────────────────
  Future<void> getStudentMark() async {
    try {
      final data = await ApiService.get('/results');
      studentMarks.value = data['results'] ?? [];
    } catch (e) {
      print('Marks error: $e');
    }
    update();
  }

  // ─── Show/Hide marks ──────────────────────────
  void showDetails() {
    isShow.value = !isShow.value;
    update();
  }

  // ─── Image picker ─────────────────────────────
  Future<void> selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      image.value = await file.readAsBytes();
      update();
      // TODO: API pe upload karna hai baad mein
    }
  }
}