import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/reciter.dart';
import '../../domain/repositories/reciter_repository.dart';
import '../datasources/reciters_data.dart';

class ReciterRepositoryImpl implements ReciterRepository {
  ReciterRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  static const String _keySelectedReciterId = 'selected_reciter_id';

  @override
  List<Reciter> getAllReciters() => List.from(kAllReciters);

  @override
  Reciter getSelectedReciter() {
    final id = _prefs.getString(_keySelectedReciterId) ??
        _prefs.getString(AppConstants.keyQuranReciter);
    if (id == null) return kAllReciters.first; // Default: Mishary Alafasy
    try {
      return kAllReciters.firstWhere((r) => r.id == id);
    } catch (_) {
      return kAllReciters.first;
    }
  }

  @override
  Future<void> setSelectedReciter(Reciter reciter) async {
    await _prefs.setString(_keySelectedReciterId, reciter.id);
    // Also sync to Quran reciter key for backward compatibility
    await _prefs.setString(AppConstants.keyQuranReciter, reciter.id);
  }
}
