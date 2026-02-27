import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/repositories/tasbeeh_repository.dart';

class TasbeehRepositoryImpl implements TasbeehRepository {
  final SharedPreferences sharedPreferences;

  TasbeehRepositoryImpl({required this.sharedPreferences});

  @override
  int getLastCount() =>
      sharedPreferences.getInt(AppConstants.keyTasbeehCount) ?? 0;

  @override
  Future<void> setCount(int count) async {
    await sharedPreferences.setInt(AppConstants.keyTasbeehCount, count);
  }
}
