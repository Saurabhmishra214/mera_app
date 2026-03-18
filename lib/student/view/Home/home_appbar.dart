import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management_system/public/utils/constant.dart';
import 'package:school_management_system/public/utils/font_style.dart';
import 'package:school_management_system/student/controllers/AnnouncementsController.dart';
import 'package:school_management_system/student/view/Announcements/AnnouncementsPage.dart';
import 'package:school_management_system/student/view/Profile/stprofile.dart';

AppBar CostumHomeAppBar({String? title, TextStyle? style, Function()? ontap}) {
  // Controller lo — already initialized hoga
  final AnnouncementsController annController =
      Get.put(AnnouncementsController());

  return AppBar(
    elevation: 5,
    title: Row(
      children: [
        Text('$title', style: style),
      ],
    ),
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: gradientColor,
        image: const DecorationImage(
          image: AssetImage('assets/images/appbar-background-squares.png'),
          fit: BoxFit.cover,
        ),
      ),
    ),
    actions: [
      Row(
        children: [

          // 🔔 Notification Bell with Badge
          Padding(
            padding: EdgeInsets.only(
                right: 10.w, top: 10.h, bottom: 26.5.h, left: 15.w),
            child: Obx(() {
              final count = annController.announcementsList.length;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.to(() => AnnouncementsPage());
                    },
                    icon: Icon(
                      Icons.notifications,
                      size: 32.w,
                      color: Colors.white,
                    ),
                  ),
                  // Badge — count > 0 ho to dikhao
                  if (count > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          count > 99 ? '99+' : count.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),

          // 👤 Profile Icon
          Padding(
            padding:
                EdgeInsets.only(right: 12.w, top: 10.h, bottom: 26.5.h),
            child: IconButton(
              onPressed: () {
                Get.to(() => StudentProfile());
              },
              icon: const Icon(
                Icons.person,
                size: 27,
                color: Colors.white,
              ),
            ),
          ),

        ],
      ),
    ],
  );
}