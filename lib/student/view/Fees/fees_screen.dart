import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:school_management_system/public/utils/constant.dart';
import 'package:school_management_system/public/utils/font_style.dart';
import 'package:school_management_system/student/controllers/fee_controller.dart';

// ══════════════════════════════════════════════════════
// MAIN FEES SCREEN
// ══════════════════════════════════════════════════════
class FeesScreen extends StatelessWidget {
  const FeesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(FeeController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Fee Details',
            style: sfMediumStyle(fontSize: 18, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () => c.getMyFees(),
          ),
        ],
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }

        return RefreshIndicator(
          color: primaryColor,
          onRefresh: () => c.getMyFees(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Summary card ──────────────────────
                _SummaryCard(c: c),

                // ── Due badge ─────────────────────────
                if (c.dueCount.value > 0)
                  _DueBanner(count: c.dueCount.value),

                SizedBox(height: 16.h),

                // ── Filter chips ──────────────────────
                _FilterChips(c: c),
                SizedBox(height: 12.h),

                // ── Monthly fee list ──────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text('Monthly Fees',
                      style: sfMediumStyle(
                          fontSize: 14, color: Colors.black87)),
                ),
                SizedBox(height: 10.h),

                if (c.filteredFees.isEmpty)
                  _EmptyState(filter: c.selectedFilter.value)
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: c.filteredFees.length,
                    itemBuilder: (_, i) {
                      final fee = c.filteredFees[i];
                      return _FeeCard(
                        fee: fee,
                        onTap: () => Get.to(
                          () => FeeReceiptScreen(feeId: fee['id'].toString()),
                        ),
                      );
                    },
                  ),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ══════════════════════════════════════════════════════
// SUMMARY CARD — Total / Paid / Pending
// ══════════════════════════════════════════════════════
class _SummaryCard extends StatelessWidget {
  final FeeController c;
  const _SummaryCard({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Fee Summary',
              style: sfRegularStyle(fontSize: 12, color: Colors.white70)),
          SizedBox(height: 4.h),
          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '₹${c.feeTotal.value.toStringAsFixed(0)}',
                style: sfMediumStyle(fontSize: 28, color: Colors.white),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  _summaryBox(
                    label: 'Paid',
                    amount: c.feePaid.value,
                    color: const Color(0xFF4ADE80),
                    icon: Icons.check_circle_outline,
                  ),
                  SizedBox(width: 10.w),
                  _summaryBox(
                    label: 'Pending',
                    amount: c.feePending.value,
                    color: const Color(0xFFFBBF24),
                    icon: Icons.hourglass_empty_rounded,
                  ),
                  SizedBox(width: 10.w),
                  _summaryBox(
                    label: 'Balance',
                    amount: c.feeTotal.value - c.feePaid.value,
                    color: const Color(0xFFF87171),
                    icon: Icons.error_outline_rounded,
                  ),
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _summaryBox({
    required String label,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 13, color: color),
                SizedBox(width: 4.w),
                Text(label,
                    style: sfRegularStyle(
                        fontSize: 10, color: Colors.white70)),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              '₹${amount.toStringAsFixed(0)}',
              style: sfMediumStyle(fontSize: 13, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// DUE BANNER
// ══════════════════════════════════════════════════════
class _DueBanner extends StatelessWidget {
  final int count;
  const _DueBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(10),
        border: const Border(
          left: BorderSide(color: Color(0xFFF59E0B), width: 4),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Color(0xFFD97706), size: 18),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              '$count month${count > 1 ? 's' : ''} ki fee pending hai. School se contact karo.',
              style: sfRegularStyle(
                  fontSize: 11, color: const Color(0xFF92400E)),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// FILTER CHIPS
// ══════════════════════════════════════════════════════
class _FilterChips extends StatelessWidget {
  final FeeController c;
  const _FilterChips({required this.c});

  static const filters = [
    {'key': 'all',     'label': 'All'},
    {'key': 'paid',    'label': 'Paid'},
    {'key': 'pending', 'label': 'Pending'},
    {'key': 'partial', 'label': 'Partial'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Obx(() => Row(
            children: filters.map((f) {
              final isSelected = c.selectedFilter.value == f['key'];
              return GestureDetector(
                onTap: () => c.setFilter(f['key']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? primaryColor
                          : const Color(0xFFE0E0E0),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : [],
                  ),
                  child: Text(
                    f['label']!,
                    style: sfMediumStyle(
                      fontSize: 12,
                      color:
                          isSelected ? Colors.white : Colors.grey[600]!,
                    ),
                  ),
                ),
              );
            }).toList(),
          )),
    );
  }
}

// ══════════════════════════════════════════════════════
// FEE CARD — Monthly row
// ══════════════════════════════════════════════════════
class _FeeCard extends StatelessWidget {
  final Map fee;
  final VoidCallback onTap;
  const _FeeCard({required this.fee, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final status  = fee['status']?.toString() ?? 'pending';
    final isPaid  = status == 'paid';
    final isPartial = status == 'partial';

    final statusColor = isPaid
        ? const Color(0xFF1D9E75)
        : isPartial
            ? const Color(0xFFBA7517)
            : const Color(0xFFD4537E);

    final statusBg = isPaid
        ? const Color(0xFFE1F5EE)
        : isPartial
            ? const Color(0xFFFAEEDA)
            : const Color(0xFFFBEAF0);

    final statusIcon = isPaid
        ? Icons.check_circle_rounded
        : isPartial
            ? Icons.timelapse_rounded
            : Icons.radio_button_unchecked_rounded;

    return GestureDetector(
      onTap: isPaid ? onTap : null, // Sirf paid ka receipt dikhao
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

            // ── Month circle ───────────────────────
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: statusBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  // Month ka short form (Jan, Feb...)
                  (fee['month']?.toString() ?? '').length >= 3
                      ? fee['month'].toString().substring(0, 3)
                      : fee['month']?.toString() ?? '',
                  style: sfMediumStyle(fontSize: 12, color: statusColor),
                ),
              ),
            ),
            SizedBox(width: 14.w),

            // ── Month + Year + Method ──────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${fee['month']} ${fee['year']}',
                    style: sfMediumStyle(
                        fontSize: 13, color: Colors.black87),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      if ((fee['payment_method'] ?? '').isNotEmpty) ...[
                        Icon(Icons.payment_rounded,
                            size: 11, color: Colors.grey),
                        SizedBox(width: 3.w),
                        Text(
                          _capitalize(fee['payment_method'].toString()),
                          style: sfRegularStyle(
                              fontSize: 10, color: Colors.grey),
                        ),
                        SizedBox(width: 8.w),
                      ],
                      if ((fee['payment_date'] ?? '').isNotEmpty) ...[
                        Icon(Icons.calendar_today_outlined,
                            size: 11, color: Colors.grey),
                        SizedBox(width: 3.w),
                        Text(
                          fee['payment_date'].toString(),
                          style: sfRegularStyle(
                              fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // ── Amount + Status ────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${double.parse(fee['amount'].toString()).toStringAsFixed(0)}',
                  style: sfMediumStyle(
                      fontSize: 15, color: Colors.black87),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 10, color: statusColor),
                      SizedBox(width: 3.w),
                      Text(
                        _capitalize(status),
                        style: sfRegularStyle(
                            fontSize: 9, color: statusColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ── Arrow (sirf paid ke liye) ──────────
            if (isPaid) ...[
              SizedBox(width: 8.w),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 13, color: Colors.grey[400]),
            ],
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ══════════════════════════════════════════════════════
// RECEIPT DETAIL SCREEN
// ══════════════════════════════════════════════════════
class FeeReceiptScreen extends StatelessWidget {
  final String feeId;
  const FeeReceiptScreen({Key? key, required this.feeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.find<FeeController>();
    c.getFeeDetail(feeId);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Fee Receipt',
            style: sfMediumStyle(fontSize: 18, color: Colors.white)),
      ),
      body: Obx(() {
        if (c.isDetailLoading.value) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }

        final fee = c.selectedFee;
        if (fee.isEmpty) {
          return Center(
            child: Text('Receipt load nahi hua',
                style: sfRegularStyle(fontSize: 13, color: Colors.grey)),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [

              // ── Receipt card ─────────────────────
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [

                    // Header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.receipt_long_rounded,
                              color: Colors.white, size: 36),
                          SizedBox(height: 8.h),
                          Text('Fee Receipt',
                              style: sfMediumStyle(
                                  fontSize: 16, color: Colors.white)),
                          SizedBox(height: 4.h),
                          if ((fee['receipt_number'] ?? '').isNotEmpty)
                            Text(
                              fee['receipt_number'],
                              style: sfRegularStyle(
                                  fontSize: 11, color: Colors.white70),
                            ),
                        ],
                      ),
                    ),

                    // Dashed divider
                    _dashedDivider(),

                    // Receipt rows
                    Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        children: [
                          _receiptRow('Student Name',
                              fee['student_name'] ?? ''),
                          _receiptRow('Roll Number',
                              fee['roll_number'] ?? ''),
                          _receiptRow('Class', fee['class'] ?? ''),
                          const Divider(
                              height: 24, color: Color(0xFFEEEEEE)),
                          _receiptRow('Month',
                              '${fee['month']} ${fee['year']}'),
                          _receiptRow('Payment Date',
                              fee['payment_date'] ?? '-'),
                          _receiptRow('Payment Method',
                              _capitalize(fee['payment_method'] ?? '')),
                          const Divider(
                              height: 24, color: Color(0xFFEEEEEE)),

                          // Amount row — big
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Amount Paid',
                                  style: sfMediumStyle(
                                      fontSize: 14,
                                      color: Colors.black87)),
                              Text(
                                '₹${double.parse(fee['amount'].toString()).toStringAsFixed(0)}',
                                style: sfMediumStyle(
                                    fontSize: 20,
                                    color: const Color(0xFF1D9E75)),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),

                          // Status badge
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1F5EE),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle_rounded,
                                    color: Color(0xFF1D9E75), size: 18),
                                SizedBox(width: 8.w),
                                Text('Payment Successful',
                                    style: sfMediumStyle(
                                        fontSize: 13,
                                        color: const Color(0xFF1D9E75))),
                              ],
                            ),
                          ),

                          if ((fee['remarks'] ?? '').isNotEmpty) ...[
                            SizedBox(height: 12.h),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F6FA),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                fee['remarks'],
                                style: sfRegularStyle(
                                    fontSize: 11, color: Colors.grey),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Copy receipt number button
              if ((fee['receipt_number'] ?? '').isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: fee['receipt_number']));
                      Get.snackbar(
                        'Copied!',
                        'Receipt number copied',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.black87,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    label: Text('Copy Receipt Number',
                        style: sfRegularStyle(fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),

              SizedBox(height: 30.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _receiptRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: sfRegularStyle(
                  fontSize: 12, color: Colors.grey[600]!)),
          Text(value,
              style: sfMediumStyle(
                  fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _dashedDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: List.generate(
          30,
          (_) => Expanded(
            child: Container(
              height: 1,
              color: _ % 2 == 0
                  ? const Color(0xFFDDDDDD)
                  : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ── Empty state ───────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final String filter;
  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(30.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: [
          Icon(Icons.receipt_outlined, size: 48, color: Colors.grey[300]),
          SizedBox(height: 12.h),
          Text(
            filter == 'all' ? 'Koi fee record nahi' : '${_capitalize(filter)} fees nahi',
            style: sfMediumStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}