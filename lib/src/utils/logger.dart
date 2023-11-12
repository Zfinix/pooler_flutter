import 'package:flutter/foundation.dart';

class PoolerLogger {
  static bool showLogs = false;
  static void log(dynamic str) {
    if (showLogs == false) {
      return;
    }
    if (kDebugMode) {
      print('PoolerLogger[log]: $str');
    }
  }

  static void e(dynamic str) {
    if (showLogs == false) {
      return;
    }
    if (kDebugMode) {
      print('PoolerLogger[error]: $str');
    }
  }
}
