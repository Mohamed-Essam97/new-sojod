abstract class HijriRepository {
  Future<int> getAdjustment();
  Future<void> setAdjustment(int days);
}
