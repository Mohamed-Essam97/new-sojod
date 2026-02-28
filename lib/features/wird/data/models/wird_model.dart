import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/wird_entity.dart';

class WirdModel extends WirdEntity {
  const WirdModel({
    required super.date,
    super.quranTargetPages,
    super.quranProgressPages,
    super.adhkarMorningDone,
    super.adhkarEveningDone,
    super.sleepDhikrDone,
    super.tasbeehTarget,
    super.tasbeehProgress,
    super.updatedAt,
  });

  factory WirdModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WirdModel(
      date: DateFormat('yyyy-MM-dd').parse(doc.id),
      quranTargetPages: data['quranTargetPages'] ?? 0,
      quranProgressPages: data['quranProgressPages'] ?? 0,
      adhkarMorningDone: data['adhkarMorningDone'] ?? false,
      adhkarEveningDone: data['adhkarEveningDone'] ?? false,
      sleepDhikrDone: data['sleepDhikrDone'] ?? false,
      tasbeehTarget: data['tasbeehTarget'] ?? 0,
      tasbeehProgress: data['tasbeehProgress'] ?? 0,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'date': DateFormat('yyyy-MM-dd').format(date),
      'quranTargetPages': quranTargetPages,
      'quranProgressPages': quranProgressPages,
      'adhkarMorningDone': adhkarMorningDone,
      'adhkarEveningDone': adhkarEveningDone,
      'sleepDhikrDone': sleepDhikrDone,
      'tasbeehTarget': tasbeehTarget,
      'tasbeehProgress': tasbeehProgress,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static String dateToDocId(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
