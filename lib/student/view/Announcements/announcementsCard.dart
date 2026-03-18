import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_management_system/public/utils/constant.dart';
import 'package:school_management_system/public/utils/font_style.dart';

class AnnouncementsCard extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final String type;

  const AnnouncementsCard({
    Key? key,
    required this.title,
    required this.content,
    required this.date,
    this.type = 'general',
  }) : super(key: key);

  // Type ke hisab se color
  Color get _typeColor {
    switch (type) {
      case 'urgent':  return Colors.red;
      case 'exam':    return Colors.orange;
      case 'holiday': return Colors.green;
      case 'event':   return Colors.blue;
      default:        return primaryColor;
    }
  }

  IconData get _typeIcon {
    switch (type) {
      case 'urgent':  return Icons.warning;
      case 'exam':    return Icons.quiz;
      case 'holiday': return Icons.celebration;
      case 'event':   return Icons.event;
      default:        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          left: BorderSide(color: _typeColor, width: 4),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Title + Icon ──────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: _typeColor.withOpacity(0.1),
                  child: Icon(_typeIcon, color: _typeColor, size: 16),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    title,
                    style: redHatMediumStyle(
                        fontSize: 15, color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Type badge
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: _typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    type.toUpperCase(),
                    style: sfRegularStyle(
                        fontSize: 9, color: _typeColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // ── Content ───────────────────────
            Text(
              content,
              style: sfRegularStyle(fontSize: 13, color: Colors.grey.shade700),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),

            // ── Date ──────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.calendar_today,
                    size: 12, color: Colors.grey.shade400),
                SizedBox(width: 4.w),
                Text(
                  date.length > 10 ? date.substring(0, 10) : date,
                  style: sfRegularStyle(
                      fontSize: 11, color: Colors.grey.shade400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}