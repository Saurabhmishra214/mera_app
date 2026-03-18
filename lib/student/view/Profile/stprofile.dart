import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_management_system/public/utils/constant.dart';
import 'package:school_management_system/public/utils/font_style.dart';
import 'package:school_management_system/student/Widgets/CustomAppBar.dart';
import '../../controllers/stprofile_controller.dart';

class StudentProfile extends StatelessWidget {
  final StprofileController c = Get.put(StprofileController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CostumAppBar(title: "Profile"),
        body: Obx(() {
          if (c.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [

                // ── Photo ───────────────────────
                SizedBox(height: 10.h),
                Stack(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 2),
                        image: DecorationImage(
                          image: c.photoUrl.value.isNotEmpty
                              ? NetworkImage(c.photoUrl.value) as ImageProvider
                              : const AssetImage('assets/images/photo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: c.selectImage,
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: gradientColor,
                            border: Border.all(color: Colors.white),
                          ),
                          child: const Icon(Icons.camera_alt,
                              size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // ── Name & Role ─────────────────
                Text(c.name.value,
                    style: redHatMediumStyle(fontSize: 20, color: Colors.black)),
                SizedBox(height: 4.h),
                Text('Student',
                    style: redHatMediumStyle(fontSize: 14, color: primaryColor)),
                SizedBox(height: 20.h),

                // ── Info Cards ──────────────────
                _infoCard([
                  _infoRow(Icons.person,       'Full Name',    c.name.value),
                  _infoRow(Icons.email,         'Email',        c.email.value),
                  _infoRow(Icons.phone,         'Phone',        c.phone.value),
                  _infoRow(Icons.people,        'Parent Phone', c.parentPhone.value),
                  _infoRow(Icons.school,        'Class',        c.className.value),
                  _infoRow(Icons.numbers,       'Roll Number',  c.rollNumber.value),
                  _infoRow(Icons.person_outline,'Gender',       c.gender.value),
                  _infoRow(Icons.location_on,   'Address',      c.address.value),
                ]),
                SizedBox(height: 16.h),

                // ── Fee Status ──────────────────
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 6,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fee Status',
                          style: redHatMediumStyle(
                              fontSize: 16, color: Colors.black)),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _feeBox('Total',   c.feeTotal.value,   Colors.blue),
                          _feeBox('Paid',    c.feePaid.value,    Colors.green),
                          _feeBox('Pending', c.feePending.value, Colors.red),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ── Helper Widgets ────────────────────────────

  Widget _infoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 22),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: redHatMediumStyle(fontSize: 11, color: Colors.grey)),
              SizedBox(height: 2.h),
              Text(
                value.isNotEmpty ? value : '-',
                style: redHatMediumStyle(fontSize: 15, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _feeBox(String label, double amount, Color color) {
    return Column(
      children: [
        Text('₹${amount.toStringAsFixed(0)}',
            style: redHatMediumStyle(fontSize: 18, color: color)),
        SizedBox(height: 4.h),
        Text(label,
            style: redHatMediumStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}