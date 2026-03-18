import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management_system/public/utils/constant.dart';
import 'package:school_management_system/public/utils/font_families.dart';
import 'package:school_management_system/public/utils/font_style.dart';
import 'package:school_management_system/student/controllers/AnnouncementsController.dart';
import 'package:school_management_system/student/view/Announcements/announcementsCard.dart';

class AnnouncementsPage extends StatelessWidget {
  AnnouncementsPage({Key? key}) : super(key: key);

  final AnnouncementsController c = Get.put(AnnouncementsController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        // ── AppBar ──────────────────────────────
        appBar: AppBar(
          elevation: 5,
          title: const Text(
            'Announcements',
            style: TextStyle(
              color: white,
              fontSize: 22,
              fontFamily: RedHatDisplay.regular,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: gradientColor,
              image: const DecorationImage(
                image: AssetImage(
                    'assets/images/appbar-background-squares.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // ── Body ────────────────────────────────
        body: Obx(() {

          // Loading
          if (c.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Empty
          if (c.announcementsList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off,
                      size: 64, color: Colors.grey.shade300),
                  SizedBox(height: 16.h),
                  Text(
                    'No announcements yet',
                    style: sfRegularStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // List
          return RefreshIndicator(
            onRefresh: c.getAnnouncements,
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: c.announcementsList.length,
              itemBuilder: (context, index) {
                final notice = c.announcementsList[index];
                return AnnouncementsCard(
                  title:   notice['title']   ?? '',
                  content: notice['content'] ?? '',
                  date:    notice['date']    ?? notice['start_date'] ?? '',
                  type:    notice['type']    ?? 'general',
                );
              },
            ),
          );
        }),
      ),
    );
  }
}