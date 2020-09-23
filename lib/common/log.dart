import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Log {
  static const String tagDebug = "debug";
  static const String tagHive = "hive";

  static void out(String tag, Object msg) {
    String msgStr = "<$tag> <${DateTime.now()}>: ${msg.toString()}";
    debugPrint(msgStr);
    msgStr += "\n";
  }

  static void err(Object msg) {
    String errorMessage = "<error> <${DateTime.now()}>: ${msg.toString()}";
    debugPrint(errorMessage);
    errorMessage += "\n";
  }
}
