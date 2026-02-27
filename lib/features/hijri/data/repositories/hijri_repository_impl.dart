import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/repositories/hijri_repository.dart';

class HijriRepositoryImpl implements HijriRepository {
  final SharedPreferences sharedPreferences;

  HijriRepositoryImpl({required this.sharedPreferences});

  @override
  Future<int> getAdjustment() async {
    return sharedPreferences.getInt(AppConstants.keyHijriAdjustment) ?? 0;
  }

  @override
  Future<void> setAdjustment(int days) async {
    await sharedPreferences.setInt(AppConstants.keyHijriAdjustment, days);
  }
}
