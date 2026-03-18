import 'package:get/get.dart';
import 'package:school_management_system/services/api_service.dart';

class FeeController extends GetxController {
  // ── State ─────────────────────────────────────────
  var isLoading      = true.obs;
  var isDetailLoading = false.obs;

  // Summary
  var feeTotal   = 0.0.obs;
  var feePaid    = 0.0.obs;
  var feePending = 0.0.obs;
  var dueCount   = 0.obs;

  // Monthly fee list
  var fees = [].obs;

  // Selected fee detail (receipt)
  var selectedFee = <String, dynamic>{}.obs;

  // ── Filter ────────────────────────────────────────
  // 'all' | 'paid' | 'pending' | 'partial'
  var selectedFilter = 'all'.obs;

  // ── Computed: filtered fees ───────────────────────
  List get filteredFees {
    if (selectedFilter.value == 'all') return fees;
    return fees
        .where((f) => f['status'] == selectedFilter.value)
        .toList();
  }

  // ── API: Fetch my fees ────────────────────────────
  Future<void> getMyFees() async {
    try {
      isLoading.value = true;
      final data = await ApiService.get('/student/fees');

      if (data['summary'] != null) {
        feeTotal.value   = double.parse(data['summary']['total'].toString());
        feePaid.value    = double.parse(data['summary']['paid'].toString());
        feePending.value = double.parse(data['summary']['pending'].toString());
        dueCount.value   = int.parse(data['summary']['due_count'].toString());
      }

      fees.value = data['fees'] ?? [];
    } catch (e) {
      print('FeeController error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ── API: Fee detail / receipt ─────────────────────
  Future<void> getFeeDetail(String feeId) async {
    try {
      isDetailLoading.value = true;
      final data = await ApiService.get('/student/fees/$feeId');
      if (data['fee'] != null) {
        selectedFee.value = Map<String, dynamic>.from(data['fee']);
      }
    } catch (e) {
      print('FeeDetail error: $e');
    } finally {
      isDetailLoading.value = false;
    }
  }

  // ── Filter change ─────────────────────────────────
  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  @override
  void onInit() {
    super.onInit();
    getMyFees();
  }
}