import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management_system/public/utils/constant.dart';
import 'package:school_management_system/public/utils/font_style.dart';
import 'package:school_management_system/student/controllers/more_controller.dart';
import 'package:school_management_system/student/view/Attendance/attendance_screen.dart';
import 'package:school_management_system/student/view/Timetable/timetable_screen.dart';

// ══════════════════════════════════════════════════════
// MORE SCREEN
// ══════════════════════════════════════════════════════
class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(MoreController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('More',
            style: sfMediumStyle(fontSize: 18, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // ── Profile Card ──────────────────────────
            Obx(() => _ProfileCard(
              name: c.studentName.value,
              className: c.studentClass.value,
            )),

            SizedBox(height: 16.h),

            // ── Menu Sections ─────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Section: Academic ─────────────
                  _SectionLabel(label: 'Academic'),
                  SizedBox(height: 8.h),

                  _MenuItem(
                    icon: Icons.calendar_month_rounded,
                    iconBg: const Color(0xFFE6F1FB),
                    iconColor: const Color(0xFF378ADD),
                    title: 'Attendance',
                    subtitle: 'Apni attendance dekho',
                    onTap: () => Get.to(() => const AttendanceScreen()),
                  ),

                  _MenuItem(
                    icon: Icons.schedule_rounded,
                    iconBg: const Color(0xFFE1F5EE),
                    iconColor: const Color(0xFF1D9E75),
                    title: 'Timetable',
                    subtitle: 'Class ka weekly schedule',
                    onTap: () => Get.to(() => const TimetableScreen()),
                  ),

                  SizedBox(height: 16.h),

                  // ── Section: Support ──────────────
                  _SectionLabel(label: 'Support'),
                  SizedBox(height: 8.h),

                  _MenuItem(
                    icon: Icons.headset_mic_rounded,
                    iconBg: const Color(0xFFFAEEDA),
                    iconColor: const Color(0xFFBA7517),
                    title: 'Contact & Help',
                    subtitle: 'School se contact karo',
                    onTap: () => _showContactSheet(context),
                  ),

                  SizedBox(height: 16.h),

                  // ── Section: Account ──────────────
                  _SectionLabel(label: 'Account'),
                  SizedBox(height: 8.h),

                  _MenuItem(
                    icon: Icons.logout_rounded,
                    iconBg: const Color(0xFFFBEAF0),
                    iconColor: const Color(0xFFD4537E),
                    title: 'Logout',
                    subtitle: 'Account se bahar niklo',
                    showArrow: false,
                    onTap: () => _showLogoutDialog(context, c),
                  ),

                  SizedBox(height: 30.h),

                  // ── App version ───────────────────
                  Center(
                    child: Text(
                      'School Management System v1.0',
                      style: sfRegularStyle(
                          fontSize: 11, color: Colors.grey[400]!),
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Logout dialog ───────────────────────────────────
  void _showLogoutDialog(BuildContext context, MoreController c) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.logout_rounded,
                color: Color(0xFFD4537E), size: 22),
            SizedBox(width: 8.w),
            Text('Logout',
                style: sfMediumStyle(
                    fontSize: 16, color: Colors.black87)),
          ],
        ),
        content: Text(
          'Kya aap logout karna chahte hain?',
          style: sfRegularStyle(fontSize: 13, color: Colors.grey[600]!),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel',
                style: sfRegularStyle(
                    fontSize: 13, color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await c.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4537E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Logout',
                style: sfMediumStyle(
                    fontSize: 13, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Contact bottom sheet ────────────────────────────
  void _showContactSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            Text('Contact & Help',
                style: sfMediumStyle(
                    fontSize: 16, color: Colors.black87)),
            SizedBox(height: 4.h),
            Text('School se seedha contact karo',
                style: sfRegularStyle(
                    fontSize: 12, color: Colors.grey)),
            SizedBox(height: 20.h),

            // Contact options
            _ContactTile(
              icon: Icons.phone_rounded,
              iconColor: const Color(0xFF1D9E75),
              iconBg: const Color(0xFFE1F5EE),
              title: 'School Helpline',
              subtitle: '+91 98765 00001',
              onTap: () {
                Get.back();
                // launch phone dialer
                // launch('tel:+919876500001');
              },
            ),

            _ContactTile(
              icon: Icons.mail_rounded,
              iconColor: const Color(0xFF378ADD),
              iconBg: const Color(0xFFE6F1FB),
              title: 'Email Support',
              subtitle: 'admin@school.com',
              onTap: () {
                Get.back();
                // launch('mailto:admin@school.com');
              },
            ),

            _ContactTile(
              icon: Icons.location_on_rounded,
              iconColor: const Color(0xFFBA7517),
              iconBg: const Color(0xFFFAEEDA),
              title: 'School Address',
              subtitle: 'Varanasi, Uttar Pradesh',
              onTap: () {
                Get.back();
                // launch Google Maps
              },
            ),

            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// PROFILE CARD
// ══════════════════════════════════════════════════════
class _ProfileCard extends StatelessWidget {
  final String name;
  final String className;
  const _ProfileCard({required this.name, required this.className});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          // Avatar circle
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withOpacity(0.5), width: 2),
            ),
            child: Center(
              child: Text(
                name.isNotEmpty
                    ? name.trim().substring(0, 1).toUpperCase()
                    : 'S',
                style: sfMediumStyle(fontSize: 26, color: Colors.white),
              ),
            ),
          ),
          SizedBox(width: 16.w),

          // Name + class
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: sfMediumStyle(fontSize: 17, color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                if (className.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      className,
                      style: sfRegularStyle(
                          fontSize: 11, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// SECTION LABEL
// ══════════════════════════════════════════════════════
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: sfMediumStyle(fontSize: 12, color: Colors.grey),
    );
  }
}

// ══════════════════════════════════════════════════════
// MENU ITEM — full width card with arrow
// ══════════════════════════════════════════════════════
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showArrow;

  const _MenuItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            SizedBox(width: 14.w),

            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: sfMediumStyle(
                          fontSize: 14, color: Colors.black87)),
                  SizedBox(height: 2.h),
                  Text(subtitle,
                      style: sfRegularStyle(
                          fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),

            // Arrow
            if (showArrow)
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FA),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: Colors.grey[400],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// CONTACT TILE (bottom sheet ke liye)
// ══════════════════════════════════════════════════════
class _ContactTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: sfMediumStyle(
                          fontSize: 13, color: Colors.black87)),
                  SizedBox(height: 2.h),
                  Text(subtitle,
                      style: sfRegularStyle(
                          fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 13, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}