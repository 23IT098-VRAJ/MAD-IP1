import 'dart:async';

class CloudSyncService {
  Future<void> syncRecords(List<Map<String, dynamic>> records) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }
}
