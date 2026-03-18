import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school_management_system/public/config/user_information.dart';
import 'package:school_management_system/public/utils/constant.dart';
import 'package:school_management_system/public/utils/font_style.dart';
import 'package:school_management_system/routes/app_pages.dart';
import 'package:school_management_system/services/api_service.dart';
import 'package:school_management_system/student/controllers/home_controller.dart';
import 'package:school_management_system/student/view/Profile/stprofile.dart';

var homeController = Get.put<HomeController>(HomeController());

class SideMenue extends StatelessWidget {
  SideMenue({this.onPress});
  final onPress;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [

            // ── Header ────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 60, bottom: 24, left: 20, right: 20),
              decoration: BoxDecoration(
                gradient: gradientColor,
              ),
              child: Column(
                children: [
                  // Profile Photo
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      Get.to(() => StudentProfile());
                    },
                    child: Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        image: DecorationImage(
                          image: UserInformation.urlAvatr.isNotEmpty
                              ? NetworkImage(UserInformation.urlAvatr)
                                  as ImageProvider
                              : const AssetImage('assets/images/photo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Name
                  Text(
                    UserInformation.fullname.isNotEmpty
                        ? UserInformation.fullname
                        : GetStorage().read('user')?['name'] ?? 'Student',
                    style: redHatMediumStyle(
                        fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 4),

                  // Class
                  Text(
                    UserInformation.clasname.isNotEmpty
                        ? UserInformation.clasname
                        : '',
                    style: sfRegularStyle(
                        fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ── Menu Items ────────────────────────
            _menuItem(
              icon: Icons.home,
              title: 'Home',
              onTap: () {
                Get.back();
                homeController.changePages(0);
              },
            ),

            _menuItem(
              icon: Icons.person,
              title: 'My Profile',
              onTap: () {
                Get.back();
                Get.to(() => StudentProfile());
              },
            ),

            _menuItem(
              icon: Icons.task,
              title: 'Tasks',
              onTap: () {
                Get.back();
                homeController.changePages(1);
              },
            ),

            _menuItem(
              icon: Icons.attachment,
              title: 'Adjuncts',
              onTap: () {
                Get.back();
                homeController.changePages(2);
              },
            ),

            _menuItem(
              icon: Icons.message,
              title: 'Chats',
              onTap: () {
                Get.back();
                homeController.changePages(3);
              },
            ),

            const Divider(color: Colors.grey, thickness: 0.5),

            // ── Report ────────────────────────────
            _menuItem(
              icon: Icons.flag,
              title: 'Report (Write a Complaint)',
              onTap: () {
                Get.back();
                _showReportDialog(context);
              },
            ),

            const Divider(color: Colors.grey, thickness: 0.5),

            // ── Logout ────────────────────────────
            _menuItem(
              icon: Icons.logout,
              title: 'Log Out',
              color: Colors.red,
              onTap: () async {
                // Token clear karo
                ApiService.clearToken();
                UserInformation.clear();
                Get.offAllNamed(AppPages.INITIAL);
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ── Menu Item Widget ──────────────────────────
  Widget _menuItem({
    required IconData icon,
    required String title,
    required Function() onTap,
    Color color = Colors.grey,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 24),
      title: Text(
        title,
        style: sfMediumStyle(fontSize: 15, color: color),
      ),
      onTap: onTap,
      horizontalTitleGap: 8,
    );
  }

  // ── Report Dialog ─────────────────────────────
  void _showReportDialog(BuildContext context) {
    final titleController   = TextEditingController();
    final contentController = TextEditingController();

    Get.defaultDialog(
      backgroundColor: Colors.white,
      title: 'Add Report',
      titleStyle: redHatMediumStyle(color: Colors.black87, fontSize: 20),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              prefixIcon: const Icon(Icons.title),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: contentController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Content',
              prefixIcon: const Icon(Icons.description),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Cancel
              OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              // Submit
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor),
                onPressed: () async {
                  if (titleController.text.isEmpty ||
                      contentController.text.isEmpty) {
                    Get.snackbar('Error', 'Please fill all fields',
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                    return;
                  }
                  // TODO: API call karo complaint ke liye
                  Get.back();
                  Get.snackbar('Success', 'Report submitted!',
                      backgroundColor: Colors.green,
                      colorText: Colors.white);
                },
                child: const Text('Submit',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
      radius: 12,
    );
  }
}