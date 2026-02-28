import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/wird_entity.dart';
import '../../domain/repositories/wird_repository.dart';
import '../models/wird_model.dart';

class WirdRepositoryImpl implements WirdRepository {
  WirdRepositoryImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  String _getTodayDocId() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  CollectionReference _getUserWirdCollection(String userId) {
    return _firestore.collection('wirds').doc(userId).collection('daily');
  }

  @override
  Future<WirdEntity?> getTodayWird(String userId) async {
    try {
      final docId = _getTodayDocId();
      final doc = await _getUserWirdCollection(userId).doc(docId).get();
      
      if (doc.exists) {
        return WirdModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<WirdEntity?> getWirdByDate(String userId, DateTime date) async {
    try {
      final docId = WirdModel.dateToDocId(date);
      final doc = await _getUserWirdCollection(userId).doc(docId).get();
      
      if (doc.exists) {
        return WirdModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveWird(String userId, WirdEntity wird) async {
    final docId = WirdModel.dateToDocId(wird.date);
    final wirdModel = WirdModel(
      date: wird.date,
      quranTargetPages: wird.quranTargetPages,
      quranProgressPages: wird.quranProgressPages,
      adhkarMorningDone: wird.adhkarMorningDone,
      adhkarEveningDone: wird.adhkarEveningDone,
      sleepDhikrDone: wird.sleepDhikrDone,
      tasbeehTarget: wird.tasbeehTarget,
      tasbeehProgress: wird.tasbeehProgress,
    );
    
    await _getUserWirdCollection(userId).doc(docId).set(wirdModel.toFirestore());
  }

  @override
  Future<void> updateWirdProgress(String userId, WirdEntity wird) async {
    final docId = WirdModel.dateToDocId(wird.date);
    final wirdModel = WirdModel(
      date: wird.date,
      quranTargetPages: wird.quranTargetPages,
      quranProgressPages: wird.quranProgressPages,
      adhkarMorningDone: wird.adhkarMorningDone,
      adhkarEveningDone: wird.adhkarEveningDone,
      sleepDhikrDone: wird.sleepDhikrDone,
      tasbeehTarget: wird.tasbeehTarget,
      tasbeehProgress: wird.tasbeehProgress,
    );
    
    await _getUserWirdCollection(userId).doc(docId).update(wirdModel.toFirestore());
  }

  @override
  Stream<WirdEntity?> watchTodayWird(String userId) {
    final docId = _getTodayDocId();
    return _getUserWirdCollection(userId).doc(docId).snapshots().map((doc) {
      if (doc.exists) {
        return WirdModel.fromFirestore(doc);
      }
      return null;
    });
  }

  @override
  Future<List<WirdEntity>> getWirdHistory(String userId, {int days = 7}) async {
    try {
      final today = DateTime.now();
      final startDate = today.subtract(Duration(days: days - 1));
      
      final snapshot = await _getUserWirdCollection(userId)
          .where('date', isGreaterThanOrEqualTo: WirdModel.dateToDocId(startDate))
          .orderBy('date', descending: true)
          .get();
      
      return snapshot.docs.map((doc) => WirdModel.fromFirestore(doc)).toList();
    } catch (e) {
      return [];
    }
  }
}
