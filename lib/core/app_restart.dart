import 'package:flutter/material.dart';

/// Triggers a full rebuild of the app (restart) so theme and locale changes
/// apply cleanly across the entire widget tree.
final ValueNotifier<int> appRestartKey = ValueNotifier<int>(0);

abstract final class AppRestart {
  static void restart() {
    appRestartKey.value++;
  }
}
