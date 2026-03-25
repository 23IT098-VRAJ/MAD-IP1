import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class CloudSyncService {
  CloudSyncService._({
    required FirebaseFirestore? firestore,
    required bool isEnabled,
  }) : _firestore = firestore,
       _isEnabled = isEnabled;

  final FirebaseFirestore? _firestore;
  final bool _isEnabled;

  bool get isEnabled => _isEnabled;

  static Future<CloudSyncService> create() async {
    try {
      await Firebase.initializeApp();
      return CloudSyncService._(
        firestore: FirebaseFirestore.instance,
        isEnabled: true,
      );
    } catch (_) {
      // Keep offline mode running even if Firebase setup is incomplete.
      return CloudSyncService._(firestore: null, isEnabled: false);
    }
  }

  Future<void> syncRecords(List<Map<String, dynamic>> records) async {
    if (!_isEnabled || _firestore == null || records.isEmpty) {
      return;
    }

    final WriteBatch batch = _firestore.batch();
    for (final Map<String, dynamic> record in records) {
      final String docId = record['id'] as String;
      final DocumentReference<Map<String, dynamic>> reference = _firestore
          .collection('sync_records')
          .doc(docId);
      batch.set(reference, record);
    }
    await batch.commit();
  }
}
