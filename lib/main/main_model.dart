import 'package:bookkeeping/main.dart';
import 'package:flutter/widgets.dart';

class MainModel {
  GlobalKey<MyAppState> mainKey;

  BuildContext get curBuildContext {
    if (mainKey != null) {
      MyAppState mainState = mainKey.currentState;
      if (mainState != null && mainState.mounted) {
        return mainKey.currentContext;
      }
    }
    return null;
  }
}

MainModel gMainModel = MainModel();
