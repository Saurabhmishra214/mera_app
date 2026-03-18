import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management_system/public/utils/constant.dart';
import 'package:school_management_system/public/utils/font_style.dart';
import 'package:school_management_system/student/controllers/home_controller.dart';
import 'package:school_management_system/student/view/Announcements/AnnouncementsPage.dart';
import 'package:school_management_system/student/view/Home/home_appbar.dart';
import 'package:school_management_system/student/view/Home/home_body.dart';
import 'package:school_management_system/student/view/Home/side_menu.dart';

final HomeController c = Get.put<HomeController>(HomeController());

class HomeStudent extends StatelessWidget {
  HomeStudent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: SideMenue(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: GetBuilder<HomeController>(
            init: HomeController(),
            builder: (c) => CostumHomeAppBar(
              title: c.currentIndex.value == 0
                  ? 'Hello, ${c.studentName.value} 👋'
                  : c.appBarTitles.value[c.currentIndex.value],
              style: redHatRegularStyle(fontSize: 20, color: Colors.white),
              ontap: () {
                Get.to(() => AnnouncementsPage());
              },
            ),
          ),
        ),
        body: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (c) {
            return c.bottomNavgationBarPages.value[c.currentIndex.value];
          },
        ),
        bottomNavigationBar: Obx(
          () => CustomNavigationBar(
            iconSize: 23.0,
            selectedColor: primaryColor,
            strokeColor: Color(0x300c18fb),
            unSelectedColor: Colors.grey[600],
            backgroundColor: Colors.white,
            borderRadius: Radius.circular(10),
            elevation: 8,
            items: [
              CustomNavigationBarItem(
                icon: const Icon(Icons.home_rounded),
                title: Text(
                  "Home",
                  style: c.currentIndex.value == 0
                      ? sfRegularStyle(fontSize: 10, color: primaryColor)
                      : sfRegularStyle(fontSize: 10, color: gray),
                ),
              ),
              CustomNavigationBarItem(
                icon: const Icon(Icons.menu_book_rounded),
                title: Text(
                  "Subjects",
                  style: c.currentIndex.value == 1
                      ? sfRegularStyle(fontSize: 10, color: primaryColor)
                      : sfRegularStyle(fontSize: 10, color: gray),
                ),
              ),
              CustomNavigationBarItem(
                icon: const Icon(Icons.bar_chart_rounded),
                title: Text(
                  "Results",
                  style: c.currentIndex.value == 2
                      ? sfRegularStyle(fontSize: 10, color: primaryColor)
                      : sfRegularStyle(fontSize: 10, color: gray),
                ),
              ),
              CustomNavigationBarItem(
                icon: const Icon(Icons.account_balance_wallet_rounded),
                title: Text(
                  "Fees",
                  style: c.currentIndex.value == 3
                      ? sfRegularStyle(fontSize: 10, color: primaryColor)
                      : sfRegularStyle(fontSize: 10, color: gray),
                ),
              ),
              CustomNavigationBarItem(
                icon: const Icon(Icons.more_horiz_rounded),
                title: Text(
                  "More",
                  style: c.currentIndex.value == 4
                      ? sfRegularStyle(fontSize: 10, color: primaryColor)
                      : sfRegularStyle(fontSize: 10, color: gray),
                ),
              ),
            ],
            currentIndex: c.currentIndex.value,
            onTap: (index) {
              c.changePages(index);
            },
          ),
        ),
      ),
    );
  }
}